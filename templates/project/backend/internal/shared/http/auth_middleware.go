package sharedhttp

import (
	"context"
	"errors"
	"strings"
	"time"

	"github.com/gofiber/fiber/v2"
)

const (
	AuthorizationHeader = "Authorization"
	BearerScheme        = "Bearer"
	LocalUserIDKey      = "userID"
	LocalEmailKey       = "email"
	LocalSessionIDKey   = "sessionID"
)

type AccessTokenClaims struct {
	Subject   string
	Email     string
	SessionID string
	Issuer    string
	IssuedAt  time.Time
	ExpiresAt time.Time
}

type AccessTokenValidator interface {
	ValidateAccessToken(ctx context.Context, token string) (*AccessTokenClaims, error)
}

type AuthMiddlewareConfig struct {
	Validator      AccessTokenValidator
	ExpectedIssuer string
	Now            func() time.Time
}

func NewAuthMiddleware(config AuthMiddlewareConfig) (fiber.Handler, error) {
	if config.Validator == nil {
		return nil, errors.New("validator is required")
	}

	if strings.TrimSpace(config.ExpectedIssuer) == "" {
		return nil, errors.New("expected issuer is required")
	}

	if config.Now == nil {
		config.Now = time.Now
	}

	return func(c *fiber.Ctx) error {
		token, err := extractBearerToken(c.Get(AuthorizationHeader))
		if err != nil {
			return unauthorized(c)
		}

		claims, err := config.Validator.ValidateAccessToken(c.UserContext(), token)
		if err != nil {
			return unauthorized(c)
		}

		if claims == nil || strings.TrimSpace(claims.Subject) == "" {
			return unauthorized(c)
		}

		if strings.TrimSpace(claims.Issuer) != config.ExpectedIssuer {
			return unauthorized(c)
		}

		if claims.ExpiresAt.IsZero() || !claims.ExpiresAt.After(config.Now()) {
			return unauthorized(c)
		}

		c.Locals(LocalUserIDKey, claims.Subject)

		if claims.Email != "" {
			c.Locals(LocalEmailKey, claims.Email)
		}

		if claims.SessionID != "" {
			c.Locals(LocalSessionIDKey, claims.SessionID)
		}

		return c.Next()
	}, nil
}

func CurrentUserID(c *fiber.Ctx) (string, bool) {
	return localString(c, LocalUserIDKey)
}

func CurrentEmail(c *fiber.Ctx) (string, bool) {
	return localString(c, LocalEmailKey)
}

func CurrentSessionID(c *fiber.Ctx) (string, bool) {
	return localString(c, LocalSessionIDKey)
}

func extractBearerToken(headerValue string) (string, error) {
	headerValue = strings.TrimSpace(headerValue)
	if headerValue == "" {
		return "", errors.New("authorization header is required")
	}

	parts := strings.Fields(headerValue)
	if len(parts) != 2 || !strings.EqualFold(parts[0], BearerScheme) {
		return "", errors.New("invalid authorization header")
	}

	if strings.TrimSpace(parts[1]) == "" {
		return "", errors.New("bearer token is required")
	}

	return parts[1], nil
}

func localString(c *fiber.Ctx, key string) (string, bool) {
	value, ok := c.Locals(key).(string)
	if !ok || strings.TrimSpace(value) == "" {
		return "", false
	}

	return value, true
}

func unauthorized(c *fiber.Ctx) error {
	return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
		"success": false,
		"message": "Unauthorized",
		"error": fiber.Map{
			"code": "UNAUTHORIZED",
		},
	})
}
