package main

import (
	"bufio"
	"fmt"
	"os"
)

func main() {

	filePath := "/home/paulo/projeto_daisy/data/99_inbox/temp_daisy_test.txt"

	file, err := os.Open(filePath)
	if err != nil {
		fmt.Println("Erro ao abrir arquivo:", err)
		return
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)

	for scanner.Scan() {
		line := scanner.Text()
		fmt.Println(line)
	}

	if err := scanner.Err(); err != nil {
		fmt.Println("Erro ao ler arquivo:", err)
	}

}
