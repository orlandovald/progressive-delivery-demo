package main

import (
	"encoding/json"
	"fmt"
	"math/rand"
	"net/http"
	"os"
	"strconv"
	"time"
)

const (
	port            = "8080"
	tagEnvVar       = "IMAGE_TAG"
	errChanceEnvVar = "ERROR_CHANCE"
)

var errorChance = 0
var imageTag = "NA"

func main() {

	if tag, ok := os.LookupEnv(tagEnvVar); ok {
		imageTag = tag
	}

	if chance, ok := os.LookupEnv(errChanceEnvVar); ok {
		if chanceInt, err := strconv.Atoi(chance); err == nil {
			errorChance = chanceInt
		}
	}

	fmt.Printf("Starting with configuration: tag = %s | errorChance = %d\n", imageTag, errorChance)

	var v [5]int
	rand.Seed(time.Now().UnixNano())
	for i := 0; i < 5; i++ {
		v[i] = rand.Intn(100)
	}
	handler := http.NewServeMux()
	handler.HandleFunc("/version", version)
	handler.HandleFunc("/healthz", health)
	fmt.Printf("Server listening in port %s\n", port)
	http.ListenAndServe(fmt.Sprintf("0.0.0.0:%s", port), handler)
}

func version(w http.ResponseWriter, r *http.Request) {
	if shouldError() {
		fmt.Println("Boom!")
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
	resp := struct {
		Version string
	}{
		Version: imageTag,
	}
	jsonBytes, err := json.Marshal(resp)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte(err.Error()))
		return
	}
	w.WriteHeader(http.StatusOK)
	w.Write(jsonBytes)
	fmt.Printf("%+v\n", resp)
}

func health(w http.ResponseWriter, r *http.Request) {
	fmt.Println("Healthy")
	fmt.Fprintf(w, `Healthy!`)
}

func shouldError() bool {
	rand.Seed(time.Now().UnixNano())
	if errorChance >= rand.Intn(100) {
		return true
	}
	return false
}
