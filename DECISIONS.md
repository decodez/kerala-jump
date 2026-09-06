# Decision log

One entry per meaningful decision. Five lines is enough. The point is that a reader
(or interviewer) can reconstruct why this project is shaped the way it is, and can
see where I overrode the tools I was using.

Format:

```
## D-00X: Short title (date)
Decision: what I chose
Options: what I considered
Why: the actual reason, including constraints like cost or time
AI involvement: none / suggested and accepted / suggested and rejected because...
```


## D-001: Core game loop genre (2026-09-06)
Decision: Endless runner — the runner auto-moves forward; the player switches lanes and jumps while obstacles scroll toward them.
Options: Endless runner vs. a free-roam 3D platformer with manual navigation.
Why: Matches the existing intent (speed increases with progress, score capped at 999 implying distance-based progression), and is a much smaller scope for a first project in an unfamiliar language than open 3D movement, a free camera, and hand-built level layouts.
AI involvement: suggested and accepted.

## D-002: Platform target for v1 (2026-09-06)
Decision: Native desktop executable only for v1. Web/WASM export is a stretch goal, not required for "done."
Options: Desktop-only vs. targeting web (WASM) from the start.
Why: "Public, runnable version everyone can enjoy" is satisfied by a downloadable binary. Adding WASM compilation on top of learning Odin and 3D game dev simultaneously compounds risk for a first project.
AI involvement: suggested and accepted.

## D-003: Visual style vs. reference image fidelity (2026-09-06)
Decision: Stylized, low-poly 3D look with warm lighting evoking an Onam-village morning. "The high fall.jpeg" is a tone/mood reference only (palette, tiled roofs, palms, traditional dress) — not a fidelity target.
Options: Chase the reference image's photoreal/painterly fidelity vs. a simplified stylized look.
Why: The reference is AI-generated concept art; matching that fidelity needs a modeling/shading/lighting pipeline far beyond a first Odin project. Stylized low-poly is achievable solo and still reads as "Kerala village, Onam morning" through color and set-dressing rather than photoreal detail.
AI involvement: suggested and accepted.

## D-004: Score persistence approach (2026-09-06)
Decision: Persist a single high score across sessions in a small local file (flat text or JSON) next to the executable.
Options: No persistence (score resets every run) vs. a persistent local high score vs. a full run history/leaderboard.
Why: The Definition of Done already called for storing the score. A single persistent high score is the smallest version of that which still makes the game feel like a game — something to beat — without cloud sync, which is explicitly out of scope.
AI involvement: suggested and accepted.

## D-005: Camera and lane structure (2026-09-06)
Decision: Third-person chase camera positioned behind and slightly above the runner, always facing forward. Movement constrained to 3 fixed lanes (left/center/right); jumping clears obstacles within a lane, lane-switching dodges obstacles blocking a lane.
Options: Fixed lanes vs. continuous free horizontal movement within a track; chase camera vs. side-on profile camera.
Why: Fixed lanes make obstacle/segment design and collision checks far simpler than continuous positioning, and is the standard, well-understood shape for this genre (Subway Surfers/Temple Run). A chase camera reads naturally with forward auto-motion; a side-on camera would fight the "running down a village street" framing.
AI involvement: suggested and accepted.

## D-006: Rendering library (2026-09-06)
Decision: raylib, via Odin's `vendor:raylib` bindings, for windowing, 3D rendering, input, and audio.
Options: raylib vs. Sokol vs. raw OpenGL/Metal via Odin's `core:sys` bindings.
Why: raylib has mature, actively maintained Odin bindings, a simple immediate-mode API well suited to a first 3D project, and built-in primitives/model loading that fit a stylized low-poly look — unlike raw OpenGL, it doesn't require writing a renderer from scratch before any gameplay exists. It also has a documented path to web export later (Emscripten) if the web stretch goal is picked up, without switching engines.
AI involvement: suggested and accepted.

## D-007: Obstacle/level generation approach (2026-09-06)
Decision: Pre-author a pool of short obstacle "segments" (fixed-length chunks defining a lane/obstacle layout). Spawn segments ahead of the player, recycle them once they pass behind the camera, and bias segment selection toward harder segments as speed increases.
Options: One long hand-authored track vs. procedural segment spawning/recycling from an authored pool vs. fully random per-obstacle placement.
Why: An endless runner needs unbounded track length, ruling out a single hand-authored track. A pool of hand-authored segments (vs. fully random per-obstacle placement) guarantees every segment is playtested and passable, while still giving endless variety by recombining them.
AI involvement: suggested and accepted.

## D-008: Behavior at the 999 score cap (2026-09-06)
Decision: Reaching a score of 999 ends the run as a deliberate "max score" win state, rather than silently capping the displayed number while the game continues.
Options: Silently clamp the displayed score at 999 while gameplay continues indefinitely; let the score overflow past 999; end the run at 999 as an intentional win condition.
Why: The 999 cap was already specified in DESIGN.md. Treating it as a genuine finish line gives it a purpose — something to design a screen and a moment around — instead of it being an arbitrary display quirk.
AI involvement: suggested and accepted.
