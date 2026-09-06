package main

import "core:math/rand"

SEGMENT_LENGTH :: 20.0
TRACK_SPAWN_AHEAD :: 40.0
TRACK_RECYCLE_BEHIND :: 20.0

Segment :: struct {
	blocked: [Lane]bool,
}

// Every entry must satisfy segment_is_fair (guarded by
// test_segment_pool_is_all_fair) — never assemble a layout that blocks all
// 3 lanes.
SEGMENT_POOL := []Segment{
	{},
	{blocked = #partial{.Left = true}},
	{blocked = #partial{.Center = true}},
	{blocked = #partial{.Right = true}},
	{blocked = #partial{.Left = true, .Right = true}},
	{blocked = #partial{.Left = true, .Center = true}},
	{blocked = #partial{.Center = true, .Right = true}},
}

segment_is_fair :: proc(s: Segment) -> bool {
	for lane in Lane {
		if !s.blocked[lane] {
			return true
		}
	}
	return false
}

Segment_Obstacles :: struct {
	items: [3]Obstacle,
	count: int,
}

segment_to_obstacles :: proc(s: Segment, start_z: f32) -> Segment_Obstacles {
	result: Segment_Obstacles
	mid_z := start_z + SEGMENT_LENGTH / 2
	for lane in Lane {
		if s.blocked[lane] {
			result.items[result.count] = Obstacle{pos = {lane_x(lane), 0.5, mid_z}, size = {1, 1, 1}}
			result.count += 1
		}
	}
	return result
}

Track :: struct {
	next_spawn_z: f32,
	obstacles:    [dynamic]Obstacle,
}

track_init :: proc() -> Track {
	return Track{next_spawn_z = SEGMENT_LENGTH}
}

track_destroy :: proc(tr: ^Track) {
	delete(tr.obstacles)
}

track_update :: proc(tr: ^Track, player_z: f32) {
	for tr.next_spawn_z < player_z + TRACK_SPAWN_AHEAD {
		s := SEGMENT_POOL[rand.int_max(len(SEGMENT_POOL))]
		placed := segment_to_obstacles(s, tr.next_spawn_z)
		for i in 0 ..< placed.count {
			append(&tr.obstacles, placed.items[i])
		}
		tr.next_spawn_z += SEGMENT_LENGTH
	}

	for i := len(tr.obstacles) - 1; i >= 0; i -= 1 {
		if tr.obstacles[i].pos.z < player_z - TRACK_RECYCLE_BEHIND {
			ordered_remove(&tr.obstacles, i)
		}
	}
}
