package main

import (
	"os"
	logging "github.com/op/go-logging"
)

const (
	LOGFMT            = "%{color}%{time:15:04:05.000000} %{shortfunc} ▶ %{level:.4s} %{id:03x}%{color:reset} %{message}"
)

//this is log file
var (
	logFile    *os.File
	logFormat                = logging.MustStringFormatter(LOGFMT)
	log                      = logging.MustGetLogger("logfile")
	Gloglevel  logging.Level = logging.DEBUG
)

func main() {
	
}
