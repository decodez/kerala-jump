# Repo structure: kerala-jump

> Decided before implementation, same as DESIGN.md. If the layout changes later,
> log why in DECISIONS.md.

## Full repo tree

```
kerala-jump/
├── README.md
├── DESIGN.md
├── DECISIONS.md
├── STRUCTURE.md
├── CONTEXT.md                  # glossary: Runner, Lane, Segment, Score, etc.
├── LICENSE
├── .gitignore                  # build output, data/highscore.txt, .DS_Store
│
├── build.sh                    # odin build src -out:kerala-jump (+ flags)
│
├── src/
│   ├── main.odin                # window init (raylib), fixed delta-time loop
│   ├── game.odin                 # state machine: menu | playing | game_over | max_score_win
│   ├── player.odin               # runner: current lane, jump arc, input → intent
│   ├── track.odin                 # segment pool, spawn-ahead / recycle-behind logic
│   ├── track_test.odin            # segment fairness: every segment leaves a lane clear
│   ├── obstacle.odin              # obstacle types + bounding boxes
│   ├── collision.odin             # AABB checks, runner vs. active obstacles
│   ├── score.odin                  # distance → score, speed curve, 999 cap → win state
│   ├── score_test.odin             # speed curve values, 999 → max_score_win transition
│   ├── highscore.odin              # local file read/write, defaults to 0 if missing/corrupt
│   ├── highscore_test.odin         # read/write roundtrip, missing/corrupt file → 0
│   └── render.odin                 # chase camera, draw calls, low-poly models/primitives
│
├── assets/
│   ├── models/                  # low-poly runner, obstacles, buildings, palms (.glb/.obj)
│   ├── textures/
│   └── audio/                   # sfx, optional background loop (stretch)
│
└── data/
    └── highscore.txt            # runtime-generated, gitignored
```

## Why this shape

One executable, no services, no network calls — so there's no `infra/`, no
`api/`, no `eval/`. The split that matters here is inside `src/`: each file is
one concern from the architecture diagram in DESIGN.md (input/player, track,
collision, score, render), so a bug in "why did I take damage" or "why didn't
the segment recycle" points at one file, not the whole loop.

`assets/` and `data/` are separated because they're different kinds of content:
`assets/` is authored, hand-placed, and committed; `data/` is generated at
runtime by playing the game and is gitignored.

The line to revisit: if the web (WASM) stretch goal from D-002 gets picked up,
`build.sh` grows a second target rather than the source layout changing.

## Naming convention

Odin files are one package (`src`) for this project's size — no sub-packages
until a concern genuinely needs its own namespace (e.g. if a second executable,
like a level-editor, appears later).

## build.sh shape

```bash
#!/usr/bin/env bash
set -euo pipefail
odin build src -out:kerala-jump -o:speed
```

Kept as a plain script, not a Makefile — one target, one command, nothing to
orchestrate yet.

## Commit order (matches the slice plan)

1. Docs: DESIGN.md, DECISIONS.md, STRUCTURE.md, CONTEXT.md, README.md, .gitignore, LICENSE
2. `main.odin` + `build.sh`: an empty raylib window that opens and closes cleanly
3. `player.odin`: runner drawn as a placeholder box, lane-switch input working
4. `obstacle.odin` + `track.odin`: one hand-placed obstacle, then segment spawn/recycle (segment-fairness rule test-first, D-009)
5. `collision.odin`: game_over on collision, restart flow
6. `score.odin` (test-first, D-009): distance-based score, speed curve, 999 → max_score_win
7. `highscore.odin` (test-first, D-009): persist and load high score, default to 0 on missing/corrupt file
8. `render.odin` polish: chase camera framing, lighting, Onam set-dressing
9. Replace placeholder boxes with real low-poly models from `assets/`
10. (stretch) web/WASM build target, per D-002
