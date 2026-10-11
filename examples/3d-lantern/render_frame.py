# Renders a 1920x1080 "game frame" for the UI mocks: lanterns (from 04 Materials/boxes.json) along a path
# at night, seen from a third-person camera behind an R15-sized character.
#   Blender --background --python render_frame.py -- <out.png>
import json
import math
import os
import sys

import bpy
from mathutils import Vector

Here = os.path.dirname(os.path.abspath(__file__))
Out = sys.argv[sys.argv.index("--") + 1]
Data = json.load(open(os.path.join(Here, "04 Materials", "boxes.json")))

for Obj in list(bpy.data.objects):
    bpy.data.objects.remove(Obj, do_unlink=True)

Mats = {}


def Mat(Name, Rgb, Emit=0.0, Rough=0.8, Metal=0.0):
    if Name in Mats:
        return Mats[Name]
    M = bpy.data.materials.new(Name)
    M.use_nodes = True
    B = next(n for n in M.node_tree.nodes if n.type == "BSDF_PRINCIPLED")
    B.inputs["Base Color"].default_value = (*[c / 255 for c in Rgb], 1)
    B.inputs["Roughness"].default_value = Rough
    B.inputs["Metallic"].default_value = Metal
    if Emit:
        B.inputs["Emission Color"].default_value = (*[c / 255 for c in Rgb], 1)
        B.inputs["Emission Strength"].default_value = Emit
    Mats[Name] = M
    return M


def Box(Size, Centre, M, RotZ=0):
    bpy.ops.mesh.primitive_cube_add(size=1, location=Centre, rotation=(0, 0, math.radians(RotZ)))
    O = bpy.context.active_object
    O.scale = Size
    O.data.materials.append(M)
    return O


Pal = Data["Palette"]
Slot = {
    "Iron": Mat("Iron", Pal["Iron"]), "IronEdge": Mat("IronEdge", Pal["IronEdge"]),
    "Brass": Mat("Brass", Pal["Brass"], Rough=0.4, Metal=0.8), "Glass": Mat("Glass", Pal["Glass"], Emit=2.2),
    "Flame": Mat("Flame", Pal["Flame"], Emit=12),
}


def Lantern(X, Y, Turn):
    Spin = math.radians(Turn)
    for B in Data["Boxes"]:
        # boxes.json is Roblox space (x, y up, z); back to Blender (x, -z, y)
        Lx, Ly, Lz = B["Position"][0], -B["Position"][2], B["Position"][1]
        Rx = Lx * math.cos(Spin) - Ly * math.sin(Spin)
        Ry = Lx * math.sin(Spin) + Ly * math.cos(Spin)
        Box((B["Size"][0], B["Size"][2], B["Size"][1]), (X + Rx, Y + Ry, Lz), Slot[B["Slot"]], Turn - B["RotY"])
    bpy.ops.object.light_add(type="POINT", location=(X, Y, 1.4))
    L = bpy.context.active_object.data
    L.color = (1.0, 0.66, 0.35)
    L.energy = 260
    L.shadow_soft_size = 0.4


Box((200, 200, 1), (0, 0, -0.5), Mat("Grass", (34, 48, 38)))
Box((8, 120, 0.2), (0, 50, 0.1), Mat("Path", (66, 58, 50)))
for I in range(8):
    Lantern(-6.5 if I % 2 == 0 else 6.5, 6 + I * 12, I * 17)
for I in range(14):
    X = (-1) ** I * (12 + (I * 7) % 9)
    Box((2.2, 2.2, 7 + (I * 5) % 5), (X, 10 + I * 8, 3.5), Mat("Trunk", (28, 24, 22)))
    Box((7, 7, 6), (X, 10 + I * 8, 9 + (I % 3)), Mat("Leaves", (22, 36, 34)), I * 23)

Body = Mat("Avatar", (92, 98, 110))
for Size, C in [((1.2, 1.2, 1.2), (0, 0, 4.6)), ((2, 1, 2), (0, 0, 3)), ((1, 1, 2), (-1.5, 0, 3)), ((1, 1, 2), (1.5, 0, 3)), ((1, 1, 2), (-0.5, 0, 1)), ((1, 1, 2), (0.5, 0, 1))]:
    Box(Size, (C[0], C[1] - 1, C[2]), Body)

World = bpy.data.worlds.get("World") or bpy.data.worlds.new("World")
bpy.context.scene.world = World
World.use_nodes = True
Bg = next(n for n in World.node_tree.nodes if n.type == "BACKGROUND")
Bg.inputs["Color"].default_value = (0.02, 0.03, 0.06, 1)
bpy.ops.object.light_add(type="SUN", rotation=(math.radians(60), 0, math.radians(-30)))
bpy.context.active_object.data.energy = 0.35
bpy.context.active_object.data.color = (0.6, 0.7, 1.0)

bpy.ops.object.camera_add(location=(2.5, -10, 7.5))
Cam = bpy.context.active_object
Cam.data.lens = 26
Cam.rotation_euler = (Vector((0, 22, 2.5)) - Cam.location).to_track_quat("-Z", "Y").to_euler()
S = bpy.context.scene
S.camera = Cam
S.render.engine = "CYCLES"
S.cycles.samples = 64
S.cycles.use_denoising = True
S.render.resolution_x, S.render.resolution_y = 1920, 1080
S.view_settings.view_transform = "Standard"
S.render.filepath = Out
bpy.ops.render.render(write_still=True)
print("FRAME", Out)
