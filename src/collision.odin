package main

import rl "vendor:raylib"

aabb_overlap :: proc(a_pos, a_size, b_pos, b_size: rl.Vector3) -> bool {
	x_overlap := abs(a_pos.x - b_pos.x) < (a_size.x + b_size.x) / 2
	y_overlap := abs(a_pos.y - b_pos.y) < (a_size.y + b_size.y) / 2
	z_overlap := abs(a_pos.z - b_pos.z) < (a_size.z + b_size.z) / 2
	return x_overlap && y_overlap && z_overlap
}
