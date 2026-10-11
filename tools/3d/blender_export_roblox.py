# Exports one collection as a GLB Roblox imports at the right size (1 unit = 1 stud, Y-up),
# plus parts.json: each mesh's centre, size and pivot in Roblox coordinates (for rigging/welding in Studio).
#
#   Blender <asset>.blend --background --python blender_export_roblox.py -- <CollectionName> [out_dir]
import json
import os
import sys

import bpy
from mathutils import Vector

Args = sys.argv[sys.argv.index("--") + 1:] if "--" in sys.argv else []
if not Args:
    raise SystemExit("usage: ... --python blender_export_roblox.py -- <CollectionName> [out_dir]")
Name = Args[0]
Out = Args[1] if len(Args) > 1 else os.path.dirname(bpy.data.filepath) or os.getcwd()
os.makedirs(Out, exist_ok=True)

Collection = bpy.data.collections.get(Name)
if not Collection:
    raise SystemExit(f"no collection called {Name}")
Meshes = [o for o in Collection.all_objects if o.type == "MESH"]


def Roblox(V):
    return [round(V.x, 4), round(V.z, 4), round(-V.y, 4)]


Parts = {}
for Obj in Meshes:
    Points = [Obj.matrix_world @ Vector(c) for c in Obj.bound_box]
    Low = Vector((min(p.x for p in Points), min(p.y for p in Points), min(p.z for p in Points)))
    High = Vector((max(p.x for p in Points), max(p.y for p in Points), max(p.z for p in Points)))
    Size = High - Low
    Parts[Obj.name] = {
        "centre": Roblox((Low + High) / 2),
        "size": [round(Size.x, 4), round(Size.z, 4), round(Size.y, 4)],
        "pivot": Roblox(Obj.matrix_world.translation),
    }
json.dump(Parts, open(os.path.join(Out, "parts.json"), "w"), indent=1)

bpy.ops.object.select_all(action="DESELECT")
for Obj in Meshes:
    Obj.select_set(True)
bpy.context.view_layer.objects.active = Meshes[0]

Glb = os.path.join(Out, f"{Name}.glb")
bpy.ops.export_scene.gltf(
    filepath=Glb,
    export_format="GLB",
    use_selection=True,
    export_yup=True,
    export_apply=True,
    export_texcoords=True,
    export_normals=True,
)
print("EXPORTED", len(Meshes), "meshes ->", Glb)
