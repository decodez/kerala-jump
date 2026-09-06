# kerala-jump

A 3D endless runner built in Odin, set in a Kerala village on Onam morning:
switch lanes and jump down a village street as the pace quickens, chasing a
high score capped at 999.

(gameplay screenshot / gif here)

## What it does

- Auto-forward runner across 3 lanes: switch lanes and jump to clear obstacles.
- Forward speed increases with distance survived; score is distance survived,
  capped at 999 — a deliberate "max score" finish line, not a display quirk.
- High score persists locally between sessions.

## Numbers

| Metric | Value |
|---|---|
| Personal high score | (fill in) |
| Reached 999 (max score)? | (fill in) |

## Run it

```bash
./build.sh
./kerala-jump
```

(gameplay recording here)

## Design

The architecture, art-style tradeoffs, and failure-mode handling are in
[DESIGN.md](DESIGN.md). Every meaningful decision — genre, platform target,
visual style, camera, rendering library, obstacle generation, the 999 score
cap — is logged in [DECISIONS.md](DECISIONS.md), including where I overrode
or accepted what my tools suggested. Domain terms (Runner, Lane, Segment,
Score, ...) are defined in [CONTEXT.md](CONTEXT.md).

## How this was built

Built with Claude Code as a pair programmer, working against the spec in
DESIGN.md. The design, the decision log, and every merge are mine: I don't
commit code I can't explain. DECISIONS.md marks where AI suggestions were
accepted and where they were overridden.

## License

MIT
