# kerala-jump

The gameplay domain for a 3D endless runner set in a Kerala village on Onam
morning. This glossary is a dictionary of terms, not a spec — see DESIGN.md
for architecture and STRUCTURE.md for how these map to files.

## Language

**Runner**:
The player character — a village man in a traditional white-and-gold mundu,
always moving forward automatically.
_Avoid_: Player, character, avatar.

**Lane**:
One of 3 fixed horizontal positions (left, center, right) the Runner can
occupy. The Runner switches Lanes to dodge Obstacles that block one.
_Avoid_: Track position, column.

**Segment**:
A fixed-length, pre-authored chunk of Lane/Obstacle layout. Segments are
spawned ahead of the Runner and recycled once they pass behind the camera;
endless variety comes from recombining a pool of Segments, not from
generating layouts from scratch.
_Avoid_: Chunk, tile, level piece.

**Obstacle**:
An object placed within a Segment that triggers Game Over on collision, or
that blocks a Lane and forces a Lane switch. Every Segment must leave at
least one Lane clear.
_Avoid_: Hazard, prop (props are non-colliding set-dressing, see below).

**Distance**:
Meters traveled forward since the run started. The single input that drives
both the Speed Curve and Score — there is no separate "progress" concept.
_Avoid_: Progress, ticks.

**Speed Curve**:
The function mapping Distance to the Runner's forward movement speed;
increases progressively as Distance grows. Governs difficulty, not Score
directly.
_Avoid_: Difficulty level, pace.

**Score**:
The player-facing number derived from Distance, capped at 999.
_Avoid_: Points, distance (Score and Distance are related but not identical —
Score is the capped, displayed form).

**Max Score Win**:
The end-of-run state triggered when Score reaches 999 — a deliberate finish
line, distinct from Game Over.
_Avoid_: Score cap, game complete.

**Game Over**:
The end-of-run state triggered by the Runner colliding with an Obstacle,
distinct from Max Score Win.
_Avoid_: Death, fail state.

**High Score**:
The best Score ever achieved across sessions, persisted in a local file and
loaded on startup; defaults to 0 if the file is missing or unreadable.
_Avoid_: Best score, save data (save data implies broader state than this
single number).
