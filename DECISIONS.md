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

## D-009: TDD scope — pure logic only, not the whole codebase (2026-09-06)
Decision: Test-drive the pure-logic modules (Speed Curve, Score/999-cap transition to Max Score Win, High Score file read/write including the missing/corrupt-file default-to-0 case, and Segment selection guaranteeing a clear lane). Rendering, input, camera framing, and movement "feel" are validated by playtesting instead, not by tests-first.
Options: Full TDD across the whole codebase; no formal testing, playtesting only; TDD limited to the pure-logic layer.
Why: This project's sibling portfolio projects mandate TDD-first, but they're backend services where correctness is the whole point. A game's feel (jump arc, camera, collision responsiveness) isn't something a unit test can validate — that needs a human playing it — so forcing tests-first there would produce tests that check numbers moved, not that the game feels right. The logic that IS deterministic and rule-based (score math, persistence, segment fairness) gets real test-first value: it's exactly the kind of code that's easy to get subtly wrong and easy to specify with a test.
AI involvement: suggested and accepted.

## D-010: Uniform obstacle collision height across visual variety (2026-09-08)
Decision: All obstacle kinds (Wall, Pookalam, Handcart) share the same collision box height (OBSTACLE_HEIGHT = 0.6), regardless of how tall each one's actual visual model is (Wall's mesh is 0.6 tall, Handcart's is 0.44, Pookalam's is nearly flat at 0.068).
Options: Match each obstacle's collision height to its actual mesh height (Wall=0.6, Handcart=~0.45, Pookalam=~0.1) so the hitbox never exceeds what's visually shown; or keep one uniform height for all kinds regardless of the visual.
Why: Uniform height is simpler code (no per-kind collision sizing) and keeps difficulty consistent across every obstacle type — clearing a pookalam takes the same jump as clearing a wall. The tradeoff, accepted knowingly: the pookalam's hitbox extends well above its nearly-flat mesh, which can read as an "invisible wall" to a player who expects to barely need to hop over it.
AI involvement: suggested matching each obstacle's collision height to its visual mesh (to avoid the invisible-wall feel); rejected in favor of uniform height for simplicity and consistent difficulty.

## D-011: Basic diffuse lighting shader added; "still looks plain" diagnosed as palette, not a bug (2026-09-08)
Decision: Added a real ambient+Lambertian diffuse shader (assets/shaders/lighting.vs/.fs, wired via src/render.odin), replacing raylib's default unlit shader. After adding it, the game still visually read as "plain" — diagnosed the full pipeline end to end rather than guessing: confirmed with a debug print that raylib does load real per-vertex colors from the .glb files (e.g. runner's first vertex = RGBA 146,96,62, not a default-white fallback), and separately confirmed with tools/blender/check_colors.py that the source vertex colors are genuinely varied and match ASSET_PROMPTS.md's intended palette per model. Conclusion: the lighting/color pipeline is working correctly: the flat look comes from the authored palette itself being uniformly pale/low-saturation across every model (e.g. wall terracotta 0.86,0.61,0.51; house cream 0.95,0.87,0.71; banana 0.80,0.87,0.71 — all close together in lightness), combined with the diffuse shader only spanning roughly 0.72-0.89 brightness on the faces the camera actually sees. Not fixed yet — logged so the next session diagnoses forward instead of re-suspecting the shader.
Options for next time (not decided yet): regenerate/repaint the models with a more saturated, higher-contrast palette; or keep the assets as-is and boost saturation/contrast in the fragment shader (cheaper, but a shader hack papering over flat source art).
Why: Wanted the actual root cause on record before ending the session, not just "lighting still looks off" — the next session should pick up from "palette is the problem," not re-litigate whether the shader works.
AI involvement: diagnosed via direct verification (debug print of loaded mesh data + Blender vertex-color inspection), not assumption; fix approach intentionally left open for the user to decide.
