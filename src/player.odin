package main

import rl "vendor:raylib"

LANE_WIDTH :: 2.0
LANE_SWITCH_SPEED :: 12.0

Lane :: enum {
	Left,
	Center,
	Right,
}

Player :: struct {
	lane: Lane,
	pos:  rl.Vector3,
}

lane_x :: proc(lane: Lane) -> f32 {
	// Camera looks toward +Z; in raylib's right-handed space that puts
	// world +X on the viewer's left, so Left/Right map opposite to the
	// world axis you'd naively expect.
	switch lane {
	case .Left:
		return LANE_WIDTH
	case .Center:
		return 0
	case .Right:
		return -LANE_WIDTH
	}
	return 0
}

player_init :: proc() -> Player {
	return Player{lane = .Center, pos = {0, RUNNER_SIZE.y / 2, 0}}
}

player_handle_input :: proc(p: ^Player) {
	if rl.IsKeyPressed(.LEFT) || rl.IsKeyPressed(.A) {
		if p.lane != .Left {
			p.lane = Lane(int(p.lane) - 1)
		}
	}
	if rl.IsKeyPressed(.RIGHT) || rl.IsKeyPressed(.D) {
		if p.lane != .Right {
			p.lane = Lane(int(p.lane) + 1)
		}
	}
}

player_update :: proc(p: ^Player, dt: f32) {
	p.pos.x = rl.Lerp(p.pos.x, lane_x(p.lane), LANE_SWITCH_SPEED * dt)
}
