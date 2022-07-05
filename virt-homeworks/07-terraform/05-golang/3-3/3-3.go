package main

import "fmt"

func Div3(first int, last int) []int {

	var result []int

	for i := first; i <= last; i++ {
		if i%3 == 0 {
			result = append(result, i)
		}
	}

	return result
}

func main() {
	fmt.Println(Div3(1, 100))
}
