package main

import (
	"go-todo-rest-api-example/pkg/app"
	"go-todo-rest-api-example/pkg/config"
)

func main() {
	config := config.GetConfig()

	app := &app.App{}
	app.Initialize(config)
	app.Run(":3000")
}
