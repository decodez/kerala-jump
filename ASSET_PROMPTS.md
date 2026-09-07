# Asset prompts

Prompts for generating the low-poly models `assets/models/` needs (via a
text-to-3D tool, or as a brief for Blender work). Written against D-003
(stylized low-poly, mood-only reference to "The high fall.jpeg" — not a
fidelity target) and the actual scale the game code uses: `RUNNER_SIZE =
0.6x1.0x0.6`, obstacles `1x0.6x1`, lanes 2 units apart.

## Shared style baseline

Repeat this in every prompt to keep results consistent:

> Stylized low-poly 3D asset, flat-shaded or simple-gradient shading, warm
> earthy color palette (terracotta, ochre, deep green, cream), clean
> geometric forms, no photorealistic detail, no fine surface texture — think
> "low-poly mobile game," not "cinematic render."

## Models

### 1. Runner (player character)

A stylized low-poly human figure, standing, mid-stride running pose. Wears a
traditional South Indian mundu (ankle-length wrap skirt) in cream-white with
a gold (kasavu) border stripe, plus a simple short-sleeved shirt. Bare feet,
short dark hair, warm brown skin tone. Simplified facial features — no fine
detail, just enough to read as a person. Proportions: roughly 1 unit tall,
slender build. Static single pose (no rig/animation needed yet). Single
mesh, low poly count, exported as .glb with origin at the base (feet),
centered on X/Z.

### 2. Obstacle — low wall / bund

A short stylized low-poly stone/brick wall segment, roughly waist-height on
the runner. Terracotta-brick or whitewashed-stone material, slightly
weathered but clean-edged (not photoreal grime). Rectangular block form, no
fine mortar detail. Fits a 1x0.6x1 unit bounding box, origin centered at the
base.

### 3. Obstacle — pookalam (flower rangoli) display

A flat, low-poly circular flower arrangement laid on the ground, concentric
rings of stylized flower shapes in marigold-orange, white, and magenta —
simplified geometric petal shapes, not realistic flowers. Sits nearly flush
with the ground (thin, a few centimeters tall) so it silhouettes clearly as
"don't step on this, jump it." Circular footprint roughly 1 unit diameter,
origin centered at the base.

### 4. Obstacle — vegetable handcart

A small stylized low-poly wooden handcart, two wheels, low wooden
side-rails, with a few simplified banana bunches and round vegetables piled
on top (low-poly blob shapes, no fine detail). Warm wood-brown with faded
painted colors on the rails. Fits roughly a 1x0.6x1 unit bounding box,
origin centered at the base.

### 5. Palm tree (coconut palm)

A stylized low-poly coconut palm tree: a slightly curved cylindrical trunk
in warm brown/grey, topped with 6-8 flat, simplified frond shapes in deep
green (not individually-leafed — solid low-poly blade shapes), with a small
cluster of low-poly coconuts near the crown. Roughly 5-6 units tall
(background scenery, taller than the runner). Origin at the base of the
trunk.

### 6. Banana plant

A stylized low-poly banana plant: a thick, slightly tapered trunk in pale
green, with 4-6 large, broad, simplified leaf blades (flat low-poly shapes,
gentle droop, no individual leaf veins) in deep green. Roughly 2 units tall.
Origin at the base.

### 7. Traditional Kerala house (background building)

A stylized low-poly single-story traditional Kerala house: whitewashed or
ochre walls, a steeply-sloped terracotta tiled roof (the roof is the most
important visual read — clean rows of low-poly roof tiles, not individually
modeled, just a tiled-texture-style surface), a simple wooden pillared
veranda/porch on the front. Roughly 3-4 units tall, low-poly box-based
construction. Origin centered at the base.

### 8. (optional/stretch) Nilavilakku — traditional oil lamp

A small stylized low-poly brass oil lamp on a stand — a simple stepped
conical base, a slender stem, and a shallow bowl on top with a stylized
flame shape (or omit the flame for a static prop). Warm brass/gold color.
Very small, roughly 0.3-0.4 units tall — decorative set-dressing, not a
gameplay obstacle. Origin at the base.

## Notes before using these

- Export everything as **.glb**, single mesh per asset, **origin at the
  base/floor** of the object (not the center) — a game-engine convention.
  Note this differs from how `Obstacle.pos` currently works in code (treated
  as the box's center); wiring in base-origin models means adjusting that
  placement math, not just swapping the draw call.
- Keep poly count deliberately low (a few hundred triangles, not thousands)
  — matches D-003 and keeps load times/build size trivial for this scope.
- None of these need rigging or animation — the game has no animation
  system yet, just static meshes drawn at a position.
