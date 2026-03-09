APP_NAME=erp

run:
	go run ./cmd/api

build:
	go build -o bin/app ./cmd/api

test:
	go test ./...

docker-build:
	docker build -t $(APP_NAME) .

docker-run:
	docker compose up --build
