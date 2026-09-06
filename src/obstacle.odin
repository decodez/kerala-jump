package main

import rl "vendor:raylib"

Obstacle :: struct {
	pos:  rl.Vector3,
	size: rl.Vector3,
}

obstacle_draw :: proc(o: Obstacle) {
	rl.DrawCube(o.pos, o.size.x, o.size.y, o.size.z, rl.DARKGREEN)
}
