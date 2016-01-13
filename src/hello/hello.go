package main

import (
	"fmt"
	zmq "github.com/alecthomas/gozmq"
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
	arg := "server"
	if len(os.Args) > 1 {
		arg = os.Args[1]
	}
	log.Info("=[%s\n]===================================================================", arg)

	path := os.Getenv("GOPATH")
	fmt.Println(path)

	path = os.Getenv("GOROOT")
	fmt.Println(path)

	syscall_path, ok := syscall.Getenv("_system_arch")
	fmt.Println(syscall_path)
	fmt.Println(ok)

	path = os.Getenv("_system_name")
	fmt.Println(path)

	if arg == "server" || arg == "" {
		log.Info("run server!")
		context, _ := zmq.NewContext()
		socket, _ := context.NewSocket(zmq.REP)
		socket.Bind("tcp://127.0.0.1:5000")
		socket.Bind("tcp://127.0.0.1:6000")

		for {
			msg, _ := socket.Recv(0)
			println("Got", string(msg))
			socket.Send(msg, 0)
		}
	} else if arg == "client" {
		log.Info("client server!")
		context, _ := zmq.NewContext()
		socket, _ := context.NewSocket(zmq.REQ)
		socket.Connect("tcp://127.0.0.1:5000")
		socket.Connect("tcp://127.0.0.1:6000")

		for i := 0; i < 10; i++ {
			msg := fmt.Sprintf("msg %d", i)
			socket.Send([]byte(msg), 0)
			println("Sending", msg)
			socket.Recv(0)
		}
	}

}
