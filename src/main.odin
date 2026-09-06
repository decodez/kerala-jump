package main

import rl "vendor:raylib"

RUNNER_SIZE :: rl.Vector3{0.6, 1.0, 0.6}

main :: proc() {
	rl.InitWindow(1280, 720, "kerala-jump")
	defer rl.CloseWindow()

	rl.SetTargetFPS(60)

	player := player_init()

	obstacle := Obstacle{pos = {0, 0.5, 10}, size = {1, 1, 1}}

	camera := rl.Camera3D {
		position   = {0, 3, -6},
		target     = {0, 0, 2},
		up         = {0, 1, 0},
		fovy       = 60,
		projection = .PERSPECTIVE,
	}

	for !rl.WindowShouldClose() {
		dt := rl.GetFrameTime()

		player_handle_input(&player)
		player_update(&player, dt)

		rl.BeginDrawing()
		rl.ClearBackground(rl.RAYWHITE)

		rl.BeginMode3D(camera)
		rl.DrawGrid(20, 1)
		rl.DrawCube(player.pos, RUNNER_SIZE.x, RUNNER_SIZE.y, RUNNER_SIZE.z, rl.MAROON)
		obstacle_draw(obstacle)
		rl.EndMode3D()

		rl.EndDrawing()
	}
}
