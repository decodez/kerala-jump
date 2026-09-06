package main

import "core:testing"

@(test)
test_segment_all_clear_is_fair :: proc(t: ^testing.T) {
	s := Segment{}
	testing.expect(t, segment_is_fair(s))
}

@(test)
test_segment_one_lane_blocked_is_fair :: proc(t: ^testing.T) {
	s := Segment{blocked = #partial{.Center = true}}
	testing.expect(t, segment_is_fair(s))
}

@(test)
test_segment_two_lanes_blocked_is_fair :: proc(t: ^testing.T) {
	s := Segment{blocked = #partial{.Left = true, .Center = true}}
	testing.expect(t, segment_is_fair(s))
}

@(test)
test_segment_all_lanes_blocked_is_not_fair :: proc(t: ^testing.T) {
	s := Segment{blocked = {.Left = true, .Center = true, .Right = true}}
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
	s := Segment{blocked = #partial{.Center = true}}
	result := segment_to_obstacles(s, 0)
	testing.expect_value(t, result.count, 1)
	testing.expect_value(t, result.items[0].pos.x, lane_x(.Center))
}

@(test)
test_segment_to_obstacles_centers_in_segment_length :: proc(t: ^testing.T) {
	s := Segment{blocked = #partial{.Left = true}}
	result := segment_to_obstacles(s, 100)
	testing.expect_value(t, result.items[0].pos.z, f32(100) + SEGMENT_LENGTH / 2)
}
