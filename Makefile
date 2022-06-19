current-dir := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

# 🔍 Test
.PHONY: test
import:
	docker exec -i repo-mysql mysql < schema.sql

# 🐳 Docker Compose
.PHONY: start
start:
	docker-compose up --build -d --remove-orphans

.PHONY: down
down:
	docker-compose down
