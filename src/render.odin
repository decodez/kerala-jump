package main

import rl "vendor:raylib"

// Fixed "sun" direction for a warm Onam morning — no day/night cycle, no
// shadows, just enough directional shading to give the low-poly forms depth.
LIGHT_DIR :: rl.Vector3{-0.35, -0.8, 0.5}

load_lighting_shader :: proc() -> rl.Shader {
	shader := rl.LoadShader("assets/shaders/lighting.vs", "assets/shaders/lighting.fs")
	light_dir := LIGHT_DIR
	loc := rl.GetShaderLocation(shader, "lightDir")
	rl.SetShaderValue(shader, loc, &light_dir, .VEC3)
	return shader
}

apply_shader :: proc(model: ^rl.Model, shader: rl.Shader) {
	model.materials[0].shader = shader
}
