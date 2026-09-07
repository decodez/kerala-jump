# Design: kerala-jump

> Written before implementation. This doc is the spec; code gets written against it.
> Author: Akhil Prasenan. Last updated: 2026-09-06.

## What this is

A 3D endless runner, built in Odin, where the player jumps and dodges down a
village lane, scoring points up to a maximum of 999. Forward speed increases as
the run progresses. The theme and vibe is a traditional Kerala village on an
Onam morning — tiled-roof houses, palm trees, a pookalam-lined street.

This is an exploratory project to learn the Odin programming language and get
hands-on with 3D game design fundamentals, not a commercial or long-lived
product.

## Why I'm building it

1. To have a public, runnable version of the game everyone can enjoy.
2. To understand and learn the Odin programming language.
3. To understand game design.

## Architecture

```
                     ┌──────────────────────────┐
                     │   raylib window + loop    │
                     │   (fixed delta-time)      │
                     └────────────┬─────────────┘
                                  │ each frame
        ┌──────────────┬─────────┼─────────┬───────────────┐
        ▼              ▼         ▼         ▼               ▼
   ┌─────────┐   ┌───────────┐ ┌──────┐ ┌────────┐   ┌───────────┐
   │  Input  │   │  Runner   │ │Track │ │ Score/ │   │  Render   │
   │ (keys)  │──▶│ (lane,    │ │(seg- │ │ Speed  │──▶│ (chase    │
   │         │   │  jump arc)│ │ ment │ │ curve  │   │  camera,  │
   └─────────┘   └─────┬─────┘ │ pool)│ └───┬────┘   │  models)  │
                        │       └──┬───┘     │        └───────────┘
                        ▼          ▼         ▼
                  ┌──────────────────────────────┐
                  │   Collision (AABB checks)     │
                  │   Runner box vs. active        │
                  │   obstacle boxes                │
                  └───────────────┬────────────────┘
                                  ▼
                     ┌──────────────────────────┐
                     │  Game state machine        │
                     │  menu → playing →           │
                     │  game_over | max_score_win  │
                     └────────────┬─────────────┘
                                  ▼
                     ┌──────────────────────────┐
                     │  High-score file (local)  │
                     │  read on start, write on   │
                     │  new best                  │
                     └──────────────────────────┘
```

Rendering/windowing/input/audio: raylib, via Odin's `vendor:raylib` bindings
(D-006). Everything else (game logic, track generation, scoring) is plain Odin.

## Scope

In scope:
- Core endless-runner loop: auto-forward movement, 3-lane switching, jumping,
  obstacle collision (D-001, D-005).
- Procedurally spawned/recycled obstacle segments, difficulty increasing with
  speed (D-007).
- Score = distance survived, capped at 999; reaching 999 is a deliberate
  "max score" win state, not a silent clamp (D-008).
- Local high-score persistence in a flat file, loaded on start, written on a
  new best (D-004).
- Stylized low-poly 3D art, Onam-village theme (tiled roofs, palm trees,
  traditional dress) — mood/tone only, not photoreal (D-003).
- Native desktop build, playable with no external runtime dependencies (D-002).

Out of scope (deliberately):
- Cloud sync, leaderboards, multiplayer.
- Web/WASM build — stretch goal, not required for v1 (D-002).
- Photorealistic rendering, custom shaders, or a lighting pipeline.

## Key decisions to make (log outcomes in DECISIONS.md)

- D-001: Core game loop genre (endless runner vs. free-roam platformer)
- D-002: Platform target for v1 (desktop vs. web)
- D-003: Visual style target vs. the reference image's fidelity
- D-004: Score persistence approach
- D-005: Camera and lane structure
- D-006: Rendering library
- D-007: Obstacle/level generation approach
- D-008: Behavior when score reaches the 999 cap
- D-009: TDD scope (pure logic vs. whole codebase)
- D-010: Uniform obstacle collision height vs. matching each visual model

## Failure modes to handle (not optional)

- **Frame-rate dependence**: forward speed, jump arcs, and the speed curve must
  be computed from delta-time, not frame count, so the game doesn't run
  faster/slower on different machines.
- **Unwinnable segments**: procedural segment selection must guarantee at least
  one clear lane through every spawned segment — never assemble a combination
  that blocks all lanes at once.
- **Collision tunneling at high speed**: as forward speed increases near the
  score cap, thin obstacles must not be skippable in a single frame's movement;
  size collision boxes or use a swept check rather than a single point-in-time
  AABB test if this shows up in testing.
- **Missing or corrupted high-score file**: on start, a missing or unreadable
  high-score file must default to 0, not crash the game.

## Definition of done

- Playable end-to-end with no errors and no external runtime dependencies
  (a single native executable).
- Player can restart after game over or after reaching the 999 max-score win
  state.
- Forward speed visibly increases over the course of a run.
- High score persists across sessions in a local file.
- Speed Curve, Score/999-cap transition, High Score persistence, and Segment
  fairness (D-009) are covered by tests written before their implementation.
- Rendering, input, and movement feel are confirmed by playtesting, not tests.
