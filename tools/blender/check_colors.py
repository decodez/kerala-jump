"""
Check whether each .glb has real, varied vertex colors baked in (vs. no
color data, which raylib silently defaults to flat white — the classic
cause of "why does everything look plain/gray" that looks like a lighting
bug but isn't).

Run headlessly:
    /Applications/Blender.app/Contents/MacOS/Blender --background --python \
        tools/blender/check_colors.py -- assets/models
"""

import bpy
import glob
import os
import sys

models_dir = sys.argv[-1]

for path in sorted(glob.glob(os.path.join(models_dir, "*.glb"))):
    bpy.ops.wm.read_factory_settings(use_empty=True)
    bpy.ops.import_scene.gltf(filepath=path)

    name = os.path.basename(path)
    for obj in bpy.context.scene.objects:
        if obj.type != "MESH":
            continue
        vcolors = list(obj.data.vertex_colors) if hasattr(obj.data, "vertex_colors") else []
        if vcolors:
            layer = vcolors[0]
            samples = [tuple(round(c, 3) for c in layer.data[i].color) for i in range(min(5, len(layer.data)))]
            unique_colors = set()
            for d in layer.data:
                unique_colors.add(tuple(round(c, 2) for c in d.color))
            print(f"  {name} vcolor samples={samples} unique_count={len(unique_colors)}")
        mats = obj.data.materials
        mat_info = []
        for m in mats:
            if m is None:
                mat_info.append("None")
                continue
            base_color = None
            if m.use_nodes:
                bsdf = m.node_tree.nodes.get("Principled BSDF")
                if bsdf:
                    base_color = tuple(round(c, 3) for c in bsdf.inputs["Base Color"].default_value)
            mat_info.append(f"{m.name} base_color={base_color}")
        print(f"{name}: vertex_color_layers={len(vcolors)} materials={mat_info}")
