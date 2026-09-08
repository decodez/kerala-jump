package main

// Shared by Track and Scenery, whose spawn/recycle cadence stays in sync —
// props line the same stretch of track the player is actually on, not a
// separately-tuned window ahead/behind.
SPAWN_AHEAD :: 40.0
RECYCLE_BEHIND :: 20.0

recycle_behind :: proc(items: ^[dynamic]$T, player_z: f32, cutoff: f32, z_of: proc(T) -> f32) {
	for i := len(items) - 1; i >= 0; i -= 1 {
		if z_of(items[i]) < player_z - cutoff {
			ordered_remove(items, i)
		}
	}
}
