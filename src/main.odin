package main

import rl "vendor:raylib"

main :: proc() {
	rl.InitWindow(1280, 720, "kerala-jump")
	defer rl.CloseWindow()

	rl.SetTargetFPS(60)

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.RAYWHITE)
		rl.EndDrawing()
	}
}
