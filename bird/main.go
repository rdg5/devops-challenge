package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"math/rand"
	"net/http"
	"net/url"
	"os"

	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promhttp"
)

var httpRequestsTotal = prometheus.NewCounterVec(
	prometheus.CounterOpts{
		Name: "http_requests_total_birdapi",
		Help: "Total number of HTTP requests",
	},
	[]string{"method", "endpoint"},
)

func init() {
	prometheus.MustRegister(httpRequestsTotal)
}

type Bird struct {
	Name        string
	Description string
	Image       string
}

func defaultBird(err error) Bird {
	return Bird{
		Name:        "Bird in disguise",
		Description: fmt.Sprintf("This bird is in disguise because: %s", err),
		Image:       "https://www.pokemonmillennium.net/wp-content/uploads/2015/11/missingno.png",
	}
}

func getBirdImage(birdName string) (string, error) {
	birdImageServiceURL := os.Getenv("BIRDIMAGEAPI_SERVICE_URL")
	if birdImageServiceURL == "" {
		birdImageServiceURL = "http://birdimageapi:4200/"
	}
	res, err := http.Get(fmt.Sprintf("%s/birdimage?birdName=%s", birdImageServiceURL, url.QueryEscape(birdName)))
	if err != nil {
		return "", err
	}
	body, err := io.ReadAll(res.Body)
	return string(body), err
}

func getBirdFactoid() Bird {
	res, err := http.Get(fmt.Sprintf("%s%d", "https://freetestapi.com/api/v1/birds/", rand.Intn(50)))
	if err != nil {
		fmt.Printf("Error reading bird API: %s\n", err)
		return defaultBird(err)
	}
	body, err := io.ReadAll(res.Body)
	if err != nil {
		fmt.Printf("Error parsing bird API response: %s\n", err)
		return defaultBird(err)
	}
	var bird Bird
	err = json.Unmarshal(body, &bird)
	if err != nil {
		fmt.Printf("Error unmarshalling bird: %s", err)
		return defaultBird(err)
	}
	birdImage, err := getBirdImage(bird.Name)
	if err != nil {
		fmt.Printf("Error in getting bird image: %s\n", err)
		return defaultBird(err)
	}
	bird.Image = birdImage
	return bird
}

func birdHandler(w http.ResponseWriter, r *http.Request) {
	httpRequestsTotal.With(prometheus.Labels{"method": r.Method, "endpoint": r.URL.Path}).Inc()

	var buffer bytes.Buffer
	json.NewEncoder(&buffer).Encode(getBirdFactoid())
	io.WriteString(w, buffer.String())
}

func main() {
	http.Handle("/metrics", promhttp.Handler())
	fmt.Println("Metrics endpoint registered at /metrics")

	http.HandleFunc("/bird", func(w http.ResponseWriter, r *http.Request) {
		fmt.Printf("Request received on path: %s\n", r.URL.Path)
		birdHandler(w, r)
	})

	fmt.Println("Starting server on port 4201")
	if err := http.ListenAndServe(":4201", nil); err != nil {
		fmt.Printf("Error starting server: %s\n", err)
	}
}
