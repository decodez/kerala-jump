package main

import rl "vendor:raylib"

// Non-colliding set-dressing (palm trees, houses) lining the street. Spawn
// and recycle on the same cadence as Track's segments, but independent of
// obstacle placement — mood only, never checked for collision.
PROP_SIDE_X :: 6.0

Prop :: struct {
	pos: rl.Vector3,
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
		append(&s.props, Prop{pos = {-PROP_SIDE_X, 0, mid_z}})
		append(&s.props, Prop{pos = {PROP_SIDE_X, 0, mid_z}})
		s.next_spawn_z += SEGMENT_LENGTH
	}

	recycle_behind(&s.props, player_z, RECYCLE_BEHIND, proc(p: Prop) -> f32 {
		return p.pos.z
	})
}
