package main

import (
	"log"
	"net/http"
	"net/http/httputil"
	"os"
	"runtime"
	"strconv"
	"time"
)

const defaultPort = 1234

var logger *log.Logger

func main() {
	port := defaultPort
	if len(os.Args) == 2 {
		port, _ = strconv.Atoi(os.Args[1])
	}

	http.HandleFunc("/", handler)

	logger = log.New(os.Stdout, "[sleepy] ", log.LstdFlags)
	logger.Printf("Sleepy built with %s\n", runtime.Version())
	logger.Fatal(http.ListenAndServe(":"+strconv.Itoa(port), nil))
}

func handler(w http.ResponseWriter, r *http.Request) {
	rawDump, _ := httputil.DumpRequest(r, true)

	logger.Println("\n" + string(rawDump))

	t := 0
	ms := r.URL.Query().Get("ms")

	if ms != "" {
		t, _ = strconv.Atoi(ms)
	}

	w.Header().Set("Server", "sleepy")
	_, _ = w.Write(rawDump)

	time.Sleep(time.Duration(t) * time.Millisecond)
}
