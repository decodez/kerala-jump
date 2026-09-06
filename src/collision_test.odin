package main

import "core:testing"

// Regression guard: an obstacle-height/jump-speed/gravity combination that
// makes a same-lane obstacle uncrossable is a real bug, even though the AABB
// math itself is correct. This locks in "jumping ~3 units before a
// same-lane obstacle clears it" so future tuning changes can't silently
// reintroduce an impossible jump.
@(test)
test_jump_from_reasonable_distance_clears_same_lane_obstacle :: proc(t: ^testing.T) {
	obstacle := Obstacle {
		pos  = {lane_x(.Center), OBSTACLE_HEIGHT / 2, 10},
		size = {1, OBSTACLE_HEIGHT, 1},
	}

	p := player_init()
	p.lane = .Center
	p.pos.z = obstacle.pos.z - 3
	p.vel_y = JUMP_SPEED

	dt: f32 = 1.0 / 60.0
	collided := false
	for frame in 0 ..< 90 {
		player_update(&p, dt)
		if aabb_overlap(p.pos, RUNNER_SIZE, obstacle.pos, obstacle.size) {
			collided = true
		}
		if p.pos.z > obstacle.pos.z + 3 {
			break
		}
	}

	testing.expect(t, !collided)
}
