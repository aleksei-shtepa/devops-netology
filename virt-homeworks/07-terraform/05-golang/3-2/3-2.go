package main

import "fmt"

func Minimum(arr []int) int {
	min := arr[0]
	for _, val := range arr {
		if val < min {
			min = val
		}
	}
	return min
}

func main() {
	x := []int{48, 96, 86, 68, 57, 82, 63, 70, 37, 34, 83, 27, 19, 97, 9, 17}

	fmt.Println("Minimum = ", Minimum(x))
}
