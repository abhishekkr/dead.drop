package main

import (
	"flag"
	"fmt"
	"html/template"
	"io"
	"net/http"
	"os"
	"path"

	"github.com/gol-gol/golfiles"
)

// Compile templates on start of the application
var (
	FlagListenAt  = flag.String("addr", ":8080", "Address to bind service at.")
	FlagUploadDir = flag.String("dir", "cut_out__espionage", "Directory to drop content at.")
	Templates     = template.Must(template.ParseFiles("public/upload.html"))
)

func main() {
	flag.Parse()
	fmt.Println("dead.drop available at:", *FlagListenAt)
	if !golfiles.PathExists(*FlagUploadDir) {
		golfiles.MkDir(*FlagUploadDir)
	}
	setupRoutes()
}

func setupRoutes() {
	http.HandleFunc("/upload", uploadHandler)
	http.ListenAndServe(*FlagListenAt, nil)
}

func uploadHandler(w http.ResponseWriter, r *http.Request) {
	switch r.Method {
	case "GET":
		display(w, "upload", nil)
	case "POST":
		uploadFile(w, r)
	}
}

// Display the named template
func display(w http.ResponseWriter, page string, data interface{}) {
	Templates.ExecuteTemplate(w, page+".html", data)
}

func uploadFile(w http.ResponseWriter, r *http.Request) {
	// Maximum upload of 10 MB files
	r.ParseMultipartForm(10 << 20)

	// Get handler for filename, size and headers
	file, handler, err := r.FormFile("myFile")
	if err != nil {
		fmt.Println("Error Retrieving the File")
		fmt.Println(err)
		return
	}

	defer file.Close()
	fmt.Printf("Uploaded File: %+v\n", handler.Filename)
	fmt.Printf("File Size: %+v\n", handler.Size)
	fmt.Printf("MIME Header: %+v\n", handler.Header)

	// Create file
	saveAs := path.Join(*FlagUploadDir, handler.Filename)
	dst, err := os.Create(saveAs)
	defer dst.Close()
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	// Copy the uploaded file to the created file on the filesystem
	if _, err := io.Copy(dst, file); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	fmt.Fprintf(w, "Successfully Uploaded File\n")
}
