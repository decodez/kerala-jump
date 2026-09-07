package main

import "core:os"
import "core:testing"

@(test)
test_parse_highscore_valid_number :: proc(t: ^testing.T) {
	testing.expect_value(t, parse_highscore("42"), 42)
}

@(test)
test_parse_highscore_trims_whitespace :: proc(t: ^testing.T) {
	testing.expect_value(t, parse_highscore("  42\n"), 42)
}

@(test)
test_parse_highscore_corrupt_content_defaults_to_zero :: proc(t: ^testing.T) {
	testing.expect_value(t, parse_highscore("not a number"), 0)
}

@(test)
test_parse_highscore_empty_content_defaults_to_zero :: proc(t: ^testing.T) {
	testing.expect_value(t, parse_highscore(""), 0)
}

@(test)
test_parse_highscore_negative_defaults_to_zero :: proc(t: ^testing.T) {
	testing.expect_value(t, parse_highscore("-5"), 0)
}

@(test)
test_highscore_load_missing_file_defaults_to_zero :: proc(t: ^testing.T) {
	testing.expect_value(t, highscore_load("does_not_exist_highscore.txt"), 0)
}

@(test)
test_highscore_save_and_load_roundtrip :: proc(t: ^testing.T) {
	path := "test_highscore_roundtrip.txt"
	defer os.remove(path)

	highscore_save(path, 777)
	testing.expect_value(t, highscore_load(path), 777)
}
