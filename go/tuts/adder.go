package main

import "fmt"

func add (x, y int) int {
	return x + y
}

func main() {
	var a,b int
	fmt.Printf("\nPlease give me your first number: ")
	fmt.Scanf("%d", &a)
	fmt.Printf("\nAnd the second: ")
	fmt.Scanf("%d", &b)
	fmt.Println("\nThe result is: ", add(a, b), "\n\n")
}
