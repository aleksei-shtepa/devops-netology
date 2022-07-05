package main

import "testing"

func TestMinimum(t *testing.T) {
	var v int
	v = Minimum([]int{48, 96, 86, 68, 57, 82, 63, 70, 37, 34, 83, 27, 19, 97, 9, 17})
	if v != 9 {
		t.Error("Expected 9, got ", v)
	}

	v = Minimum([]int{0})
	if v != 0 {
		t.Error("Expected 0, got ", v)
	}

	v = Minimum([]int{48, 96, 86, 68, 57, 82, 63, 70, 37, 34, 83, 27, 19, 97, 9, -17})
	if v != -17 {
		t.Error("Expected -17, got ", v)
	}

	v = Minimum([]int{48, 96, 86, 68, 57, 82, 63, 0, 37, 34, 83, 27, 19, 97, 9, 17})
	if v != 0 {
		t.Error("Expected 0, got ", v)
	}
}
