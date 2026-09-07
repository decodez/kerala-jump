package main

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

HIGHSCORE_DIR :: "data"
HIGHSCORE_PATH :: "data/highscore.txt"

parse_highscore :: proc(content: string) -> int {
	value, ok := strconv.parse_int(strings.trim_space(content))
	if !ok || value < 0 {
		return 0
	}
	return value
}

highscore_load :: proc(path: string) -> int {
	data, err := os.read_entire_file(path, context.allocator)
	if err != nil {
		return 0
	}
	defer delete(data)
	return parse_highscore(string(data))
}

highscore_save :: proc(path: string, score: int) {
	os.make_directory(HIGHSCORE_DIR)
	content := fmt.tprintf("%d", score)
	_ = os.write_entire_file(path, transmute([]u8)content)
}
