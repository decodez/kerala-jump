package main

import "core:testing"

@(test)
test_segment_all_clear_is_fair :: proc(t: ^testing.T) {
	s := Segment{}
	testing.expect(t, segment_is_fair(s))
}

@(test)
test_segment_one_lane_blocked_is_fair :: proc(t: ^testing.T) {
	s := Segment{kind = #partial{.Center = .Wall}}
	testing.expect(t, segment_is_fair(s))
}

@(test)
test_segment_two_lanes_blocked_is_fair :: proc(t: ^testing.T) {
	s := Segment{kind = #partial{.Left = .Wall, .Center = .Pookalam}}
	testing.expect(t, segment_is_fair(s))
}

@(test)
test_segment_all_lanes_blocked_is_not_fair :: proc(t: ^testing.T) {
	s := Segment{kind = {.Left = .Wall, .Center = .Pookalam, .Right = .Handcart}}
	testing.expect(t, !segment_is_fair(s))
}

@(test)
test_segment_to_obstacles_empty_segment_has_none :: proc(t: ^testing.T) {
	s := Segment{}
	result := segment_to_obstacles(s, 0)
	testing.expect_value(t, result.count, 0)
}

@(test)
test_segment_to_obstacles_places_one_per_blocked_lane :: proc(t: ^testing.T) {
	s := Segment{kind = #partial{.Center = .Wall}}
	result := segment_to_obstacles(s, 0)
	testing.expect_value(t, result.count, 1)
	testing.expect_value(t, result.items[0].pos.x, lane_x(.Center))
}

@(test)
test_segment_to_obstacles_centers_in_segment_length :: proc(t: ^testing.T) {
	s := Segment{kind = #partial{.Left = .Wall}}
	result := segment_to_obstacles(s, 100)
	testing.expect_value(t, result.items[0].pos.z, f32(100) + SEGMENT_LENGTH / 2)
}

@(test)
test_segment_to_obstacles_carries_the_obstacle_kind :: proc(t: ^testing.T) {
	s := Segment{kind = #partial{.Right = .Pookalam}}
	result := segment_to_obstacles(s, 0)
	testing.expect_value(t, result.items[0].kind, Obstacle_Kind.Pookalam)
}

@(test)
test_segment_pool_is_all_fair :: proc(t: ^testing.T) {
	for s in SEGMENT_POOL {
		testing.expect(t, segment_is_fair(s))
	}
}
