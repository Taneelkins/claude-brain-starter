# Lantern: rebuilds the asset for one stage, renders front / side / 3-4 / lineup, writes boxes.json.
#   Blender --background --python build_lantern.py -- <blockout|detail|materials> <out_dir>
# 1 unit = 1 stud, Z up. Origin at the base centre.
import json
import math
import os
import sys

import bpy
from mathutils import Vector

Args = sys.argv[sys.argv.index("--") + 1:] if "--" in sys.argv else ["materials", os.getcwd()]
Stage, Out = Args[0], Args[1]
os.makedirs(Out, exist_ok=True)

Palette = {
    "Iron": (0.09, 0.085, 0.08),
    "IronEdge": (0.2, 0.18, 0.16),
    "Brass": (0.62, 0.42, 0.16),
    "Glass": (1.0, 0.5, 0.14),
    "Flame": (1.0, 0.62, 0.18),
    "Wood": (0.3, 0.19, 0.11),
    "Grey": (0.55, 0.55, 0.55),
    "Dummy": (0.35, 0.37, 0.4),
}

# (name, size xyz, centre xyz, slot, z-rotation degrees, stage it appears from)
Boxes = [
    ("Base", (2.0, 2.0, 0.3), (0, 0, 0.15), "Iron", 0, "blockout"),
    ("Body", (1.6, 1.6, 2.0), (0, 0, 1.3), "Glass", 0, "blockout"),
    ("Cap", (2.0, 2.0, 0.35), (0, 0, 2.475), "Iron", 0, "blockout"),
    ("Roof", (1.3, 1.3, 0.45), (0, 0, 2.875), "Iron", 0, "blockout"),
    ("Handle", (0.2, 1.4, 0.2), (0, 0, 3.85), "Brass", 0, "blockout"),
    # detail pass
    ("BaseStep", (1.7, 1.7, 0.15), (0, 0, 0.375), "IronEdge", 0, "detail"),
    ("CapStep", (1.75, 1.75, 0.15), (0, 0, 2.225), "IronEdge", 0, "detail"),
    ("RoofTip", (0.7, 0.7, 0.25), (0, 0, 3.225), "IronEdge", 45, "detail"),
    ("HandleL", (0.2, 0.2, 0.75), (0, -0.6, 3.375), "Brass", 0, "blockout"),
    ("HandleR", (0.2, 0.2, 0.75), (0, 0.6, 3.375), "Brass", 0, "blockout"),
    ("Flame", (0.35, 0.35, 0.6), (0, 0, 1.0), "Flame", 45, "detail"),
    ("FlameTip", (0.2, 0.2, 0.3), (0, 0, 1.4), "Flame", 20, "detail"),
    ("Wick", (0.5, 0.5, 0.2), (0, 0, 0.55), "Brass", 0, "detail"),
]
for X in (-1, 1):
    for Y in (-1, 1):
        Boxes.append((f"Post{X}{Y}", (0.25, 0.25, 2.0), (X * 0.8, Y * 0.8, 1.3), "Iron", 0, "detail"))
for Side, (X, Y, W, D) in {"F": (0, -0.82, 1.4, 0.08), "B": (0, 0.82, 1.4, 0.08), "L": (-0.82, 0, 0.08, 1.4), "R": (0.82, 0, 0.08, 1.4)}.items():
    Boxes.append((f"Bar{Side}", (W, D, 0.12), (X, Y, 1.3), "Iron", 0, "detail"))

Order = {"blockout": 0, "detail": 1, "materials": 2}
Active = [b for b in Boxes if Order[b[5]] <= Order[Stage]]

for Obj in list(bpy.data.objects):
    bpy.data.objects.remove(Obj, do_unlink=True)

Mats = {}


def Material(Slot):
    Key = Slot if Stage == "materials" or Slot == "Dummy" else "Grey"
    if Key in Mats:
        return Mats[Key]
    Mat = bpy.data.materials.new(Key)
    Mat.use_nodes = True
    Bsdf = next(n for n in Mat.node_tree.nodes if n.type == "BSDF_PRINCIPLED")
    Bsdf.inputs["Base Color"].default_value = (*Palette[Key], 1)
    Bsdf.inputs["Roughness"].default_value = 0.75
    if Key == "Flame":
        Bsdf.inputs["Emission Color"].default_value = (*Palette["Flame"], 1)
        Bsdf.inputs["Emission Strength"].default_value = 12
    if Key == "Glass":
        Bsdf.inputs["Emission Color"].default_value = (*Palette["Glass"], 1)
        Bsdf.inputs["Emission Strength"].default_value = 2.2
    if Key in ("Brass",):
        Bsdf.inputs["Metallic"].default_value = 0.8
        Bsdf.inputs["Roughness"].default_value = 0.4
    Mats[Key] = Mat
    return Mat


def Box(Name, Size, Centre, Slot, Rot=0, Offset=(0, 0, 0)):
    bpy.ops.mesh.primitive_cube_add(size=1, location=Vector(Centre) + Vector(Offset), rotation=(0, 0, math.radians(Rot)))
    Obj = bpy.context.active_object
    Obj.name = Name
    Obj.scale = Size
    bpy.ops.object.transform_apply(location=False, rotation=False, scale=True)
    Obj.data.materials.append(Material(Slot))
    return Obj


for Name, Size, Centre, Slot, Rot, _ in Active:
    Box(Name, Size, Centre, Slot, Rot)

# R15-sized stand-in for scale (about 5.2 studs tall), 3 studs to the left
Dummy = [("Head", (1.2, 1.2, 1.2), (0, 0, 4.6)), ("Torso", (2, 1, 2), (0, 0, 3)), ("ArmL", (1, 1, 2), (-1.5, 0, 3)),
         ("ArmR", (1, 1, 2), (1.5, 0, 3)), ("LegL", (1, 1, 2), (-0.5, 0, 1)), ("LegR", (1, 1, 2), (0.5, 0, 1))]
DummyObjs = [Box("Dummy" + n, s, c, "Dummy", 0, (-4, 0, 0)) for n, s, c in Dummy]

# ground + light
bpy.ops.mesh.primitive_plane_add(size=60, location=(0, 0, 0))
Ground = bpy.context.active_object
GroundMat = bpy.data.materials.new("Ground")
GroundMat.use_nodes = True
next(n for n in GroundMat.node_tree.nodes if n.type == "BSDF_PRINCIPLED").inputs["Base Color"].default_value = (0.16, 0.17, 0.2, 1)
Ground.data.materials.append(GroundMat)

World = bpy.data.worlds.get("World") or bpy.data.worlds.new("World")
bpy.context.scene.world = World
World.use_nodes = True
Bg = next(n for n in World.node_tree.nodes if n.type == "BACKGROUND")
Night = Stage == "materials"
Bg.inputs["Color"].default_value = (0.03, 0.04, 0.07, 1) if Night else (0.55, 0.57, 0.6, 1)
Bg.inputs["Strength"].default_value = 1.0
bpy.ops.object.light_add(type="SUN", rotation=(math.radians(50), 0, math.radians(35)))
bpy.context.active_object.data.energy = 0.6 if Night else 3.0

Scene = bpy.context.scene
Scene.render.engine = "CYCLES"
Scene.cycles.samples = 48
Scene.cycles.use_denoising = True
Scene.render.resolution_x = Scene.render.resolution_y = 800
# Standard is closest to how Roblox shows colour; AgX/Filmic wash bright emissives out to cream
Scene.view_settings.view_transform = "Standard"


def Shot(Name, Location, Target, Lens=70, Hide=()):
    for Obj in Hide:
        Obj.hide_render = True
    bpy.ops.object.camera_add(location=Location)
    Cam = bpy.context.active_object
    Cam.data.lens = Lens
    Direction = Vector(Target) - Cam.location
    Cam.rotation_euler = Direction.to_track_quat("-Z", "Y").to_euler()
    Scene.camera = Cam
    Scene.render.filepath = os.path.join(Out, Name + ".png")
    bpy.ops.render.render(write_still=True)
    for Obj in Hide:
        Obj.hide_render = False


Mid = (0, 0, 1.8)
Shot("front", (0, -14, 1.9), Mid, 70, DummyObjs)
Shot("side", (14, 0, 1.9), Mid, 70, DummyObjs)
Shot("three_quarter", (9.5, -10, 5.5), Mid, 70, DummyObjs)
Shot("lineup", (-2, -22, 3), (-2, 0, 2.4), 70)

# box data in Roblox coordinates (x, z, -y) for rebuilding from Parts in Studio
Data = [{"Name": n, "Size": [s[0], s[2], s[1]], "Position": [c[0], c[2], -c[1]], "RotY": -r, "Slot": slot}
        for n, s, c, slot, r, _ in Active]
json.dump({"Palette": {k: [round(v * 255) for v in c] for k, c in Palette.items()}, "Boxes": Data}, open(os.path.join(Out, "boxes.json"), "w"), indent=1)
Tris = 12 * len(Active)
print(f"STAGE {Stage}: {len(Active)} boxes, {Tris} tris, height {max(c[2] + s[2] / 2 for _, s, c, *_ in Active):.2f} studs")
