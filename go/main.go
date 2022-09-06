package main

import (
	"fmt"
	"math/rand"
	"net/http"
	"os"
	"strconv"
	"time"
)

const (
	port            = "8080"
	colorEnvVar     = "IMAGE_TAG"
	errChanceEnvVar = "ERROR_CHANCE"
)

var errorChance = 0
var color = "green"

func main() {

	if colorEnv, ok := os.LookupEnv(colorEnvVar); ok {
		color = colorEnv
	}

	if chance, ok := os.LookupEnv(errChanceEnvVar); ok {
		if chanceInt, err := strconv.Atoi(chance); err == nil {
			errorChance = chanceInt
		}
	}

	fmt.Printf("Starting with configuration: colorEnvVar = %s | errorChance = %d\n", color, errorChance)

	var v [5]int
	rand.Seed(time.Now().UnixNano())
	for i := 0; i < 5; i++ {
		v[i] = rand.Intn(100)
	}
	handler := http.NewServeMux()
	handler.HandleFunc("/hit", hit)
	handler.HandleFunc("/healthz", health)
	handler.Handle("/", http.FileServer(http.Dir("./static")))
	fmt.Printf("Server listening in port %s\n", port)
	http.ListenAndServe(fmt.Sprintf("0.0.0.0:%s", port), handler)
}

func hit(w http.ResponseWriter, r *http.Request) {
	lineType := "ok"
	status := http.StatusOK
	if shouldError() {
		status = http.StatusInternalServerError
		lineType = "error"
	}
	resp := fmt.Sprintf("<div class='square lined %s' style='background-color: %s'>%s</div>", lineType, color, color)
	fmt.Println(resp)
	w.WriteHeader(status)
	fmt.Fprint(w, resp)
}

func health(w http.ResponseWriter, r *http.Request) {
	fmt.Println("Healthy")
	fmt.Fprintf(w, `Healthy!`)
}

func shouldError() bool {
	rand.Seed(time.Now().UnixNano())
	if errorChance >= rand.Intn(100)+1 {
		return true
	}
	return false
}
