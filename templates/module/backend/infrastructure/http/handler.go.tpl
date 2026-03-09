package http

import "github.com/gofiber/fiber/v2"

type Handler struct {}

func (h *Handler) Create(c *fiber.Ctx) error {
	return c.Status(501).JSON(fiber.Map{
		"error": "not implemented",
	})
}
