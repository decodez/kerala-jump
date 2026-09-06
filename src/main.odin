package main

import rl "vendor:raylib"

RUNNER_SIZE :: rl.Vector3{0.6, 1.0, 0.6}

main :: proc() {
	rl.InitWindow(1280, 720, "kerala-jump")
	defer rl.CloseWindow()

	rl.SetTargetFPS(60)

	runner_pos := rl.Vector3{0, RUNNER_SIZE.y / 2, 0}

	camera := rl.Camera3D {
		position   = runner_pos + {0, 3, -6},
		target     = runner_pos + {0, 0, 2},
		up         = {0, 1, 0},
		fovy       = 60,
		projection = .PERSPECTIVE,
	}

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.RAYWHITE)

		rl.BeginMode3D(camera)
		rl.DrawGrid(20, 1)
		rl.DrawCube(runner_pos, RUNNER_SIZE.x, RUNNER_SIZE.y, RUNNER_SIZE.z, rl.MAROON)
		rl.EndMode3D()

		rl.EndDrawing()
	}
}
