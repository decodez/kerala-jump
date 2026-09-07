"""
Report each .glb's mesh count, dimensions, height range, and horizontal
center — the facts that matter before wiring a model into the game (does it
match the size assumed in ASSET_PROMPTS.md, is its origin at the base or the
center).

Run headlessly:
    /Applications/Blender.app/Contents/MacOS/Blender --background --python \
        tools/blender/inspect_models.py -- assets/models
"""

import bpy
import glob
import os
import sys

models_dir = sys.argv[-1]

for path in sorted(glob.glob(os.path.join(models_dir, "*.glb"))):
    bpy.ops.wm.read_factory_settings(use_empty=True)
    bpy.ops.import_scene.gltf(filepath=path)

    min_co = [float("inf")] * 3
    max_co = [float("-inf")] * 3
    mesh_count = 0

    for obj in bpy.context.scene.objects:
        if obj.type != "MESH":
            continue
        mesh_count += 1
        for corner in obj.bound_box:
            world_corner = obj.matrix_world @ __import__("mathutils").Vector(corner)
            for i in range(3):
                min_co[i] = min(min_co[i], world_corner[i])
                max_co[i] = max(max_co[i], world_corner[i])

    name = os.path.basename(path)
    if mesh_count == 0:
        print(f"{name}: NO MESHES FOUND")
        continue

    size = [max_co[i] - min_co[i] for i in range(3)]
    # Blender is Z-up natively; the glTF importer converts glTF's Y-up into
    # Blender's Z-up automatically. So Blender's Z here IS the vertical
    # (height) axis, not Y.
    print(
        f"{name}: meshes={mesh_count} "
        f"size(x,y,z)=({size[0]:.3f},{size[1]:.3f},{size[2]:.3f}) "
        f"min_z(height)={min_co[2]:.3f} max_z(height)={max_co[2]:.3f} "
        f"center_xy=({(min_co[0]+max_co[0])/2:.3f},{(min_co[1]+max_co[1])/2:.3f})"
    )
