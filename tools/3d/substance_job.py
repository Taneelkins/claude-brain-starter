# One-shot Substance 3D Painter job: new project from a mesh -> bake mesh maps -> base + grime + edge layers
# -> export Roblox PBR PNGs (BaseColor, Normal, Roughness, Metalness) -> save .spp. Then it deletes itself.
#
# Use:
#   1. Write substance_job.json next to this file (in Painter's python/startup folder):
#      {"Mesh": "/abs/Sword.fbx", "Out": "/abs/04 Materials/substance",
#       "BaseColor": [0.42, 0.27, 0.15], "Roughness": 0.7, "Metallic": 0.0,
#       "Grime": [0.06, 0.05, 0.05], "GrimeOpacity": 0.5, "Edge": [0.8, 0.78, 0.72], "EdgeOpacity": 0.3,
#       "BaseColorMap": null}
#      (BaseColorMap: optional path to an existing colour atlas PNG used instead of BaseColor)
#   2. Copy this file to ~/Documents/Adobe/Adobe Substance 3D Painter/python/startup/
#   3. open -a "Adobe Substance 3D Painter"   then watch <Out>/job_log.txt for "== job DONE"
#
# Painter gotchas this handles: projects open in legacy colour mode where colour fills are refused,
# so colours become tiny solid PNGs; opacity is set per active channel.
import json
import os
import struct
import traceback
import zlib

import substance_painter.baking as baking
import substance_painter.colormanagement as cm
import substance_painter.event as event
import substance_painter.export as export
import substance_painter.layerstack as layerstack
import substance_painter.project as project
import substance_painter.resource as resource
import substance_painter.textureset as textureset
from PySide6 import QtCore

JOB = os.path.join(os.path.dirname(os.path.abspath(__file__)), "substance_job.json")
CT = textureset.ChannelType
_state = {"queue": [], "cfg": None, "solids": {}, "space": {}}


def cfg():
    return _state["cfg"]


def log(*a):
    with open(os.path.join(cfg()["Out"], "job_log.txt"), "a") as fh:
        fh.write(" ".join(str(x) for x in a) + "\n")


def _png(path, rgb):
    raw = b"".join(b"\x00" + bytes(int(max(0, min(1, c)) * 255 + 0.5) for c in rgb) * 8 for _ in range(8))

    def chunk(t, d):
        return struct.pack(">I", len(d)) + t + d + struct.pack(">I", zlib.crc32(t + d) & 0xFFFFFFFF)

    with open(path, "wb") as fh:
        fh.write(b"\x89PNG\r\n\x1a\n" + chunk(b"IHDR", struct.pack(">IIBBBBB", 8, 8, 8, 2, 0, 0, 0))
                 + chunk(b"IDAT", zlib.compress(raw)) + chunk(b"IEND", b""))


def set_value(node, channel, rgb, raw=False):
    """Try a real colour first; fall back to an 8x8 solid PNG (legacy colour mode refuses colours)."""
    L = getattr(cm, "LegacyColorSpace", None)
    G = cm.GenericColorSpace
    tries = [_state["space"][raw]] if raw in _state["space"] else [None, G.Raw if raw else G.sRGB, G.Working] + (
        [L.Linear if raw else L.sRGB, L.sRGB, L.Linear] if L else [])
    for space in tries:
        try:
            node.set_source(channel, cm.Color(*rgb, space))
            _state["space"][raw] = space
            return
        except Exception:
            pass
    name = "solid_%s_%d_%d_%d.png" % ((("raw" if raw else "col"),) + tuple(int(c * 1000) for c in rgb))
    path = os.path.join(cfg()["Out"], "solids", name)
    os.makedirs(os.path.dirname(path), exist_ok=True)
    if not os.path.exists(path):
        _png(path, rgb)
    if path not in _state["solids"]:
        _state["solids"][path] = resource.import_project_resource(path, resource.Usage.TEXTURE).identifier()
    node.set_source(channel, _state["solids"][path])


def safe(fn):
    def run(*a, **k):
        try:
            fn(*a, **k)
        except Exception:
            log("ERROR in", fn.__name__, traceback.format_exc())
            finish(False)
    return run


def start_plugin():
    if not os.path.exists(JOB):
        return
    _state["cfg"] = json.load(open(JOB))
    os.makedirs(cfg()["Out"], exist_ok=True)
    log("== job start", cfg()["Mesh"])
    QtCore.QTimer.singleShot(4000, safe(step_create))


def close_plugin():
    pass


def step_create():
    if project.is_open():
        project.close()
    settings = project.Settings(normal_map_format=project.NormalMapFormat.OpenGL,
                                default_texture_resolution=2048,
                                export_path=os.path.join(cfg()["Out"], "export"))
    project.create(cfg()["Mesh"], settings=settings)
    log("project created:", [t.name for t in textureset.all_texture_sets()])
    project.execute_when_not_busy(safe(step_bake))


def step_bake():
    usages = [u for u in (getattr(textureset.MeshMapUsage, n, None) for n in
              ("AO", "Curvature", "WorldSpaceNormal", "Position", "Thickness", "Normal", "ID")) if u is not None]
    _state["queue"] = list(textureset.all_texture_sets())
    for ts in _state["queue"]:
        baking.BakingParameters.from_texture_set(ts).set_enabled_bakers(usages)
    event.DISPATCHER.connect(event.BakingProcessEnded, on_bake_end)
    bake_next()


def bake_next():
    if not _state["queue"]:
        event.DISPATCHER.disconnect(event.BakingProcessEnded, on_bake_end)
        project.execute_when_not_busy(safe(step_layers))
        return
    ts = _state["queue"].pop(0)
    log("baking", ts.name)
    baking.bake_async(ts)


def on_bake_end(e):
    log("bake ended:", getattr(e, "status", e))
    QtCore.QTimer.singleShot(500, safe(bake_next))


def find_generator(*names):
    found = resource.search("u:generator")
    for want in names:
        for r in found:
            if want.lower() in r.gui_name().lower():
                return r
    return None


def fill(stack, name, above=None):
    pos = layerstack.InsertPosition.above_node(above) if above else layerstack.InsertPosition.from_textureset_stack(stack)
    layer = layerstack.insert_fill(pos)
    layer.set_name(name)
    return layer


def opacity(layer, value):
    for ch in layer.active_channels:
        layer.set_opacity(value, ch)


def masked(layer, generator):
    layer.add_mask(layerstack.MaskBackground.Black)
    if generator is not None:
        layerstack.insert_generator_effect(
            layerstack.InsertPosition.inside_node(layer, layerstack.NodeStack.Mask), generator.identifier())


def step_layers():
    c = cfg()
    dirt = find_generator("Dirt", "Ambient Occlusion", "Occlusion")
    edge = find_generator("Edges Uber", "Curvature", "Edge")
    log("generators: dirt =", dirt and dirt.gui_name(), "edge =", edge and edge.gui_name())
    for ts in textureset.all_texture_sets():
        stack = ts.get_stack()
        base = fill(stack, "Base")
        base.active_channels = {CT.BaseColor, CT.Roughness, CT.Metallic}
        if c.get("BaseColorMap"):
            base.set_source(CT.BaseColor, resource.import_project_resource(c["BaseColorMap"], resource.Usage.TEXTURE).identifier())
        else:
            set_value(base, CT.BaseColor, c.get("BaseColor", [0.5, 0.5, 0.5]))
        r, m = c.get("Roughness", 0.7), c.get("Metallic", 0.0)
        set_value(base, CT.Roughness, (r, r, r), raw=True)
        set_value(base, CT.Metallic, (m, m, m), raw=True)

        grime = fill(None, "Grime", above=base)
        grime.active_channels = {CT.BaseColor, CT.Roughness}
        set_value(grime, CT.BaseColor, c.get("Grime", [0.06, 0.05, 0.05]))
        set_value(grime, CT.Roughness, (0.9, 0.9, 0.9), raw=True)
        opacity(grime, c.get("GrimeOpacity", 0.5))
        masked(grime, dirt)

        wear = fill(None, "Edge wear", above=grime)
        wear.active_channels = {CT.BaseColor}
        set_value(wear, CT.BaseColor, c.get("Edge", [0.8, 0.78, 0.72]))
        opacity(wear, c.get("EdgeOpacity", 0.3))
        masked(wear, edge)
    log("layers built")
    project.execute_when_not_busy(safe(step_export))


def step_export():
    out = os.path.join(cfg()["Out"], "export")
    os.makedirs(out, exist_ok=True)

    def rgb(kind, name):
        return [{"destChannel": ch, "srcChannel": ch, "srcMapType": kind, "srcMapName": name} for ch in "RGB"]

    def gray(name):
        return [{"destChannel": "L", "srcChannel": "L", "srcMapType": "documentMap", "srcMapName": name}]

    config = {
        "exportShaderParams": False,
        "exportPath": out,
        "defaultExportPreset": "roblox",
        "exportPresets": [{"name": "roblox", "maps": [
            {"fileName": "$textureSet_BaseColor", "channels": rgb("documentMap", "basecolor")},
            {"fileName": "$textureSet_Normal", "channels": rgb("virtualMap", "Normal_OpenGL")},
            {"fileName": "$textureSet_Roughness", "channels": gray("roughness")},
            {"fileName": "$textureSet_Metalness", "channels": gray("metallic")},
        ]}],
        "exportList": [{"rootPath": t.name} for t in textureset.all_texture_sets()],
        "exportParameters": [{"parameters": {"fileFormat": "png", "bitDepth": "8", "dithering": True,
                                             "sizeLog2": 10, "paddingAlgorithm": "infinite"}}],
    }
    result = export.export_project_textures(config)
    log("export:", result.status, result.message)
    for k, v in result.textures.items():
        log("  ", k, v)
    project.save_as(os.path.join(cfg()["Out"], os.path.splitext(os.path.basename(cfg()["Mesh"]))[0] + ".spp"))
    finish(True)


def finish(ok):
    log("== job", "DONE" if ok else "FAILED")
    for path in (JOB, os.path.abspath(__file__)):
        try:
            os.remove(path)
        except OSError:
            pass
