package http

import "github.com/gofiber/fiber/v2"

func RegisterRoutes(app *fiber.App, handler *Handler) {
	group := app.Group("/{{module}}")

	group.Post("/", handler.Create)
}
