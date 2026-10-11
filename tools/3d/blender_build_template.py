# Build-script template: rebuilds one asset from scratch, so every stage is reproducible.
# Copy it into the asset's stage folder as build_<asset>.py, set Asset + BlendFile, write the shapes in Build().
#
#   live (Blender MCP):  exec(open("<path>/build_<asset>.py").read())
#   headless:            Blender --background --python build_<asset>.py
#
# 1 Blender unit = 1 stud. Z is up in Blender (Roblox Y). Origin goes at the base.
import os
import bpy
from mathutils import Vector

Here = os.path.dirname(os.path.abspath(__file__)) if "__file__" in globals() else os.getcwd()
Asset = "Crate"
BlendFile = os.path.join(Here, f"{Asset}.blend")

# --- safety: this script wipes its collection. refuse to run inside some other open .blend ---
Open = bpy.data.filepath
if Open and os.path.abspath(Open) != os.path.abspath(BlendFile):
    raise SystemExit(f"refusing to run: open file is {Open}, this script owns {BlendFile}")

Palette = {
    "Wood": (0.42, 0.27, 0.15),
    "Metal": (0.18, 0.18, 0.2),
}


def Material(Name):
    Mat = bpy.data.materials.get(Name) or bpy.data.materials.new(Name)
    Mat.use_nodes = True
    Bsdf = next(n for n in Mat.node_tree.nodes if n.type == "BSDF_PRINCIPLED")
    Bsdf.inputs["Base Color"].default_value = (*Palette[Name], 1)
    Bsdf.inputs["Roughness"].default_value = 0.8
    return Mat


def Box(Collection, Name, Size, Position, Mat, Rotation=(0, 0, 0)):
    bpy.ops.mesh.primitive_cube_add(size=1, location=Position, rotation=Rotation)
    Obj = bpy.context.active_object
    Obj.name = Name
    Obj.scale = Size
    bpy.ops.object.transform_apply(location=False, rotation=False, scale=True)
    Obj.data.materials.append(Material(Mat))
    for Old in Obj.users_collection:
        Old.objects.unlink(Obj)
    Collection.objects.link(Obj)
    return Obj


def Build(Collection):
    # the asset as data: (name, size xyz in studs, position xyz, material)
    Box(Collection, "Body", (2, 2, 2), (0, 0, 1), "Wood")
    for X in (-1, 1):
        Box(Collection, f"Band{X}", (0.15, 2.05, 2), (X * 0.9, 0, 1), "Metal")


def Main():
    Old = bpy.data.collections.get(Asset)
    if Old:
        for Obj in list(Old.objects):
            bpy.data.objects.remove(Obj, do_unlink=True)
        bpy.data.collections.remove(Old)
    Collection = bpy.data.collections.new(Asset)
    bpy.context.scene.collection.children.link(Collection)

    Build(Collection)

    Low = min((Obj.matrix_world @ Vector(c)).z for Obj in Collection.objects for c in Obj.bound_box)
    Tris = 0
    for Obj in Collection.objects:
        Obj.data.calc_loop_triangles()
        Tris += len(Obj.data.loop_triangles)
    print(f"BUILT {Asset}: {len(Collection.objects)} meshes, ~{Tris} tris, lowest point z={Low:.3f}")

    bpy.ops.wm.save_as_mainfile(filepath=BlendFile)
    print("SAVED", BlendFile)


Main()
