SHELL := /bin/sh

APP_NAME ?= backend
ENV_FILE ?= .env

.PHONY: help fmt tidy build test run verify postman-validate docker-config docker-up docker-down docker-logs docker-ps docker-rebuild db-up db-down

help:
	@printf "\n$(APP_NAME) targets:\n\n"
	@printf "  make fmt\n"
	@printf "  make tidy\n"
	@printf "  make build\n"
	@printf "  make test\n"
	@printf "  make run\n"
	@printf "  make verify\n"
	@printf "  make postman-validate\n"
	@printf "  make docker-config\n"
	@printf "  make docker-up\n"
	@printf "  make docker-down\n"
	@printf "  make docker-logs\n"
	@printf "  make docker-ps\n"
	@printf "  make docker-rebuild\n"
	@printf "  make db-up\n"
	@printf "  make db-down\n\n"

fmt:
	gofmt -w ./cmd ./internal

tidy:
	go mod tidy

build:
	go build ./...

test:
	go test ./...

run:
	@set -a; \
	if [ -f "$(ENV_FILE)" ]; then . "$(ENV_FILE)"; fi; \
	set +a; \
	go run ./cmd/api

postman-validate:
	jq empty postman/base.postman_collection.json
	jq empty postman/local.postman_environment.json

verify: fmt tidy build postman-validate

docker-config:
	docker compose config

docker-up:
	docker compose up --build

docker-down:
	docker compose down

docker-logs:
	docker compose logs -f

docker-ps:
	docker compose ps

docker-rebuild:
	docker compose up --build -d

db-up:
	docker compose up -d postgres

db-down:
	docker compose stop postgres
