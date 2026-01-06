.PHONY: init up down logs status rebuild clean clean-confirm logs-core logs-next logs-bot restart-bot health help

# Default target
.DEFAULT_GOAL := help

# Colors for output
GREEN := \033[0;32m
YELLOW := \033[0;33m
NC := \033[0m # No Color

help: ## Show this help message
	@echo "$(GREEN)Available commands:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(YELLOW)%-15s$(NC) %s\n", $$1, $$2}'

init: ## Initialize workspace: init submodules and setup environment
	@echo "$(GREEN)Initializing PusjWorkspace...$(NC)"
	@if [ ! -f .gitmodules ]; then \
		echo "$(YELLOW)Copying .gitmodules.example to .gitmodules$(NC)"; \
		cp .gitmodules.example .gitmodules; \
	fi
	@bash init-submodules.sh
	@if [ ! -f .env ]; then \
		echo "$(YELLOW)Creating .env from .env.example (if exists)$(NC)"; \
		if [ -f .env.example ]; then cp .env.example .env; fi; \
	fi
	@echo "$(GREEN)Initialization complete!$(NC)"

up: ## Start all services
	@echo "$(GREEN)Starting PusjWorkspace services...$(NC)"
	docker compose -f docker-compose.dev.yml up -d --build
	@echo "$(GREEN)Services started!$(NC)"
	@echo "$(YELLOW)Core API: http://localhost:8000$(NC)"
	@echo "$(YELLOW)Next.js App: http://localhost:3000$(NC)"

down: ## Stop all services
	@echo "$(GREEN)Stopping PusjWorkspace services...$(NC)"
	docker compose -f docker-compose.dev.yml down
	@echo "$(GREEN)Services stopped!$(NC)"

logs: ## Show logs from all services
	docker compose -f docker-compose.dev.yml logs -f

status: ## Show status of all services
	@echo "$(GREEN)Service status:$(NC)"
	@docker compose -f docker-compose.dev.yml ps

rebuild: ## Rebuild and restart all services
	@echo "$(GREEN)Rebuilding services...$(NC)"
	docker compose -f docker-compose.dev.yml up -d --build
	@echo "$(GREEN)Services rebuilt and started!$(NC)"

clean: ## Stop services and remove volumes (WARNING: removes data)
	@echo "$(YELLOW)WARNING: This will remove all volumes and data!$(NC)"
	@echo "$(YELLOW)Run 'make clean-confirm' to proceed, or 'docker-compose -f docker-compose.dev.yml down -v' directly$(NC)"

clean-confirm: ## Actually remove volumes (use after 'make clean')
	docker compose -f docker-compose.dev.yml down -v
	@echo "$(GREEN)Cleanup complete!$(NC)"

logs-core: ## Show logs from core service
	docker compose -f docker-compose.dev.yml logs -f core

logs-next: ## Show logs from next service
	docker compose -f docker-compose.dev.yml logs -f next

logs-bot: ## Show logs from bot service
	docker compose -f docker-compose.dev.yml logs -f bot

restart-bot: ## Restart bot service
	docker compose -f docker-compose.dev.yml restart bot

health: ## Check core health endpoint
	@echo "$(GREEN)Checking core health...$(NC)"
	@curl -sS http://localhost:8000/health || echo "$(YELLOW)Core is not responding$(NC)"

