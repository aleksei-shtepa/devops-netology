package main

import "fmt"

func MetrToFoot(metr float32) float32 {
	return metr * 0.3048
}

func main() {
	fmt.Println("Конвертор длины из метров в футы.")
	fmt.Println("Вводите значения в метрах или пустое значение для выхода.")

	var iter bool = true
	var input float32

	for iter {
		fmt.Print("Значение в метрах: ")
		var n, _ = fmt.Scanf("%f", &input)
		if n > 0 {
			fmt.Println(MetrToFoot(input), "футов")
		} else {
			iter = false
		}

	}

}
