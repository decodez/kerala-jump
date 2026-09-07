package main

import rl "vendor:raylib"

RUNNER_SIZE :: rl.Vector3{0.6, 1.0, 0.6}

main :: proc() {
	rl.InitWindow(1280, 720, "kerala-jump")
	defer rl.CloseWindow()

	rl.SetTargetFPS(60)

	player := player_init()

	track := track_init()
	defer track_destroy(&track)

	camera := rl.Camera3D {
		position   = {0, 3, -6},
		target     = {0, 0, 2},
		up         = {0, 1, 0},
		fovy       = 60,
		projection = .PERSPECTIVE,
	}

	state := Game_State.Playing

	for !rl.WindowShouldClose() {
		dt := rl.GetFrameTime()

		switch state {
		case .Playing:
			player_handle_input(&player)
			player_update(&player, dt)
			track_update(&track, player.pos.z)

			for o in track.obstacles {
				if aabb_overlap(player.pos, RUNNER_SIZE, o.pos, o.size) {
					state = .Game_Over
					break
				}
			}
			if is_max_score(player.pos.z) {
				state = .Max_Score_Win
			}
		case .Game_Over, .Max_Score_Win:
			if rl.IsKeyPressed(.ENTER) {
				player = player_init()
				track_destroy(&track)
				track = track_init()
				state = .Playing
			}
		}

		camera.position = {0, 3, player.pos.z - 6}
		camera.target = {0, 0, player.pos.z + 2}

		rl.BeginDrawing()
		rl.ClearBackground(rl.RAYWHITE)

		rl.BeginMode3D(camera)
		rl.DrawGrid(20, 1)
		rl.DrawCube(player.pos, RUNNER_SIZE.x, RUNNER_SIZE.y, RUNNER_SIZE.z, rl.MAROON)
		for o in track.obstacles {
			obstacle_draw(o)
		}
		rl.EndMode3D()

		score := score_for_distance(player.pos.z)
		rl.DrawText(rl.TextFormat("SCORE: %03d", i32(score)), 20, 20, 24, rl.BLACK)

		switch state {
		case .Playing:
		case .Game_Over:
			rl.DrawText("GAME OVER - press Enter to restart", 320, 340, 24, rl.BLACK)
		case .Max_Score_Win:
			rl.DrawText("MAX SCORE! 999 - press Enter to restart", 280, 340, 24, rl.DARKGREEN)
		}

		rl.EndDrawing()
	}
}
