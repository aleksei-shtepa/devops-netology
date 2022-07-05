package main

import "testing"

func TestMetrToFoot(t *testing.T) {
	var v float32
	v = MetrToFoot(43)
	if v != 13.1064005 {
		t.Error("Expected 13.1064005, got ", v)
	}

	v = MetrToFoot(-1)
	if v != -0.3048 {
		t.Error("Expected -0.3048, got ", v)
	}

	v = MetrToFoot(0)
	if v != 0 {
		t.Error("Expected 0, got ", v)
	}

	v = MetrToFoot(0.3)
	if v != 0.09144001 {
		t.Error("Expected 0.09144001, got ", v)
	}
}
