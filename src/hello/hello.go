package main

import (
	"fmt"
	logging "github.com/op/go-logging"
	"os"
	"syscall"
)

const (
	LOGFMT = "%{color}%{time:15:04:05.000000} %{shortfunc} ▶ %{level:.4s} %{id:03x}%{color:reset} %{message}"
)

//this is log file
var (
	logFile   *os.File
	logFormat               = logging.MustStringFormatter(LOGFMT)
	log                     = logging.MustGetLogger("logfile")
	Gloglevel logging.Level = logging.DEBUG
)

func main() {
	log.Info("=[PATH]===================================================================")

	path := os.Getenv("GOPATH")
	fmt.Println(path)

	path = os.Getenv("GOROOT")
	fmt.Println(path)

	syscall_path, ok := syscall.Getenv("_system_arch")
	fmt.Println(syscall_path)
	fmt.Println(ok)
	
	path = os.Getenv("_system_name")
	fmt.Println(path)
	
	
	
	
	
}
