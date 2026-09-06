package main

BASE_SPEED :: 6.0
SPEED_GROWTH :: 0.05
MAX_SPEED :: 20.0
MAX_SCORE :: 999

speed_for_distance :: proc(distance: f32) -> f32 {
	speed := BASE_SPEED + distance * SPEED_GROWTH
	return min(speed, f32(MAX_SPEED))
}

score_for_distance :: proc(distance: f32) -> int {
	return min(int(distance), MAX_SCORE)
}

is_max_score :: proc(distance: f32) -> bool {
	return score_for_distance(distance) >= MAX_SCORE
}
