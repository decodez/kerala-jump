package main

import rl "vendor:raylib"

Obstacle :: struct {
	pos:  rl.Vector3,
	size: rl.Vector3,
}

obstacle_draw :: proc(o: Obstacle, model: rl.Model) {
	// Models are authored with origin at the base; Obstacle.pos is
	// center-based for collision math (tested), so the offset is applied
	// only here.
	render_pos := o.pos - rl.Vector3{0, o.size.y / 2, 0}
	rl.DrawModel(model, render_pos, 1.0, rl.WHITE)
}
