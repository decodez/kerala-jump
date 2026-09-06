package main

import "core:testing"

@(test)
test_speed_at_zero_distance_is_base_speed :: proc(t: ^testing.T) {
	testing.expect_value(t, speed_for_distance(0), f32(BASE_SPEED))
}

@(test)
test_speed_increases_with_distance :: proc(t: ^testing.T) {
	testing.expect(t, speed_for_distance(200) > speed_for_distance(0))
}

@(test)
test_speed_is_capped_at_max_speed :: proc(t: ^testing.T) {
	testing.expect_value(t, speed_for_distance(100000), f32(MAX_SPEED))
}

@(test)
test_score_equals_distance_below_cap :: proc(t: ^testing.T) {
	testing.expect_value(t, score_for_distance(500), 500)
}

@(test)
test_score_is_capped_at_max_score :: proc(t: ^testing.T) {
	testing.expect_value(t, score_for_distance(5000), MAX_SCORE)
}

@(test)
test_is_max_score_false_below_cap :: proc(t: ^testing.T) {
	testing.expect(t, !is_max_score(500))
}

@(test)
test_is_max_score_true_at_cap :: proc(t: ^testing.T) {
	testing.expect(t, is_max_score(999))
}

@(test)
test_is_max_score_true_beyond_cap :: proc(t: ^testing.T) {
	testing.expect(t, is_max_score(1500))
}
