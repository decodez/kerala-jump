package main

SEGMENT_LENGTH :: 20.0

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
