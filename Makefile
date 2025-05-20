.PHONY: up down logs export-workflows import-workflows export-credentials import-credentials import-all export-all

# Docker Compose コマンド
COMPOSE_EXEC = docker compose exec -T n8n

up:
	docker compose up -d

down:
	docker compose down

logs:
	docker compose logs -f n8n

# n8n CLI コマンド
# ファイルの出力先/入力元はコンテナ内のパスを指定します。
# docker-compose.yamlでホストの./workflows と ./credentialsがそれぞれコンテナの /home/node/workflows と /home/node/credentials にマウントされています。

export-workflows:
	$(COMPOSE_EXEC) sh -c "mkdir -p /tmp/workflows && chmod -R +wr /tmp/workflows"
	$(COMPOSE_EXEC) npx n8n export:workflow --backup --output=/tmp/workflows/
	docker cp n8n:/tmp/workflows .

import-workflows:
	@for f in `find workflows -type f -name "*.json"`; do $(COMPOSE_EXEC) npx n8n import:workflow --input=/home/node/$$f; done

export-credentials:
	$(COMPOSE_EXEC) sh -c "mkdir -p /tmp/credentials && chmod -R +wr /tmp/credentials"
	$(COMPOSE_EXEC) npx n8n export:credentials --backup --output=/tmp/credentials/
	docker cp n8n:/tmp/credentials .

import-credentials:
	@for f in `find credentials -type f -name "*.json"`; do $(COMPOSE_EXEC) npx n8n import:credentials --input=/home/node/$$f; done

import-all:
	make import-workflows
	make import-credentials

export-all:
	make export-workflows
	make export-credentials
