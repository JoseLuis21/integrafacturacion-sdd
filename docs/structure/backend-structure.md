backend/
├── .env.example
├── .dockerignore
├── Dockerfile
├── Makefile
├── docker-compose.yml
├── cmd/
│   └── api/
│       └── main.go
├── internal/
│   ├── bootstrap/
│   ├── shared/
│   │   └── http/
│   │       └── auth_middleware.go
│   ├── platform/
│   │   └── database/
│   │       ├── migrations.go
│   │       └── migrations/
│   └── modules/
│       ├── auth/
│       ├── product/
│       └── customer/
├── postman/
│   ├── base.postman_collection.json
│   └── local.postman_environment.json
└── test/
