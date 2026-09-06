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
