package main

import "core:math/rand"
import rl "vendor:raylib"

// Non-colliding set-dressing (palm trees, houses) lining the street. Spawn
// and recycle on the same cadence as Track's segments, but independent of
// obstacle placement — mood only, never checked for collision.
PROP_SIDE_X :: 6.0

Prop_Kind :: enum {
	Palm,
	Banana,
	House,
}

random_prop_kind :: proc() -> Prop_Kind {
	return Prop_Kind(rand.int_max(len(Prop_Kind)))
}

Prop :: struct {
	pos:  rl.Vector3,
	kind: Prop_Kind,
}

// Prop.pos is base-origin directly (unlike Obstacle, never used for
// collision, so no center offset is needed).
scenery_draw :: proc(p: Prop, models: [Prop_Kind]rl.Model) {
	rl.DrawModel(models[p.kind], p.pos, 1.0, rl.WHITE)
}

Scenery :: struct {
	next_spawn_z: f32,
	props:        [dynamic]Prop,
}

scenery_init :: proc() -> Scenery {
	return Scenery{next_spawn_z = SEGMENT_LENGTH}
}

scenery_destroy :: proc(s: ^Scenery) {
	delete(s.props)
}

scenery_update :: proc(s: ^Scenery, player_z: f32) {
	for s.next_spawn_z < player_z + SPAWN_AHEAD {
		mid_z := s.next_spawn_z + SEGMENT_LENGTH / 2
		append(&s.props, Prop{pos = {-PROP_SIDE_X, 0, mid_z}, kind = random_prop_kind()})
		append(&s.props, Prop{pos = {PROP_SIDE_X, 0, mid_z}, kind = random_prop_kind()})
		s.next_spawn_z += SEGMENT_LENGTH
	}

	recycle_behind(&s.props, player_z, RECYCLE_BEHIND, proc(p: Prop) -> f32 {
		return p.pos.z
	})
}
