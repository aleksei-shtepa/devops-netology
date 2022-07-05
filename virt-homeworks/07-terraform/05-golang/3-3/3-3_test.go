package main

import (
	"reflect"
	"testing"
)

func check(v, etalon []int, t *testing.T) {
	if !reflect.DeepEqual(v, etalon) {
		t.Error("Expected ", etalon, " got ", v)
	}
}

func TestDiv3(t *testing.T) {

	check(
		Div3(1, 100),
		[]int{3, 6, 9, 12, 15, 18, 21, 24, 27, 30, 33, 36, 39, 42, 45, 48, 51, 54, 57, 60, 63, 66, 69, 72, 75, 78, 81, 84, 87, 90, 93, 96, 99},
		t)

	check(
		Div3(0, 101),
		[]int{0, 3, 6, 9, 12, 15, 18, 21, 24, 27, 30, 33, 36, 39, 42, 45, 48, 51, 54, 57, 60, 63, 66, 69, 72, 75, 78, 81, 84, 87, 90, 93, 96, 99},
		t)

	check(
		Div3(30, 60),
		[]int{30, 33, 36, 39, 42, 45, 48, 51, 54, 57, 60},
		t)

	check(
		Div3(3, 3),
		[]int{3},
		t)
}
