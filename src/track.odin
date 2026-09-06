package main

Segment :: struct {
	blocked: [Lane]bool,
}

segment_is_fair :: proc(s: Segment) -> bool {
	for lane in Lane {
		if !s.blocked[lane] {
			return true
		}
	}
	return false
}
