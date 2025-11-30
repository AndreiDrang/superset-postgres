# Docker image configuration
IMAGE_NAME := andreidrang/psycopg-superset
VERSION := 5.0.4
DOCKERFILE := Dockerfile
BUILD_CONTEXT := .

# Default target
.DEFAULT_GOAL := help

# Help target
help: ## Show this help message
	@echo "Available targets:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

build: ## Build Docker image
	docker build -t $(IMAGE_NAME):$(VERSION) -f $(DOCKERFILE) $(BUILD_CONTEXT)

build-latest: ## Build Docker image with latest tag
	docker build -t $(IMAGE_NAME):latest -f $(DOCKERFILE) $(BUILD_CONTEXT)

tag-latest: ## Tag the versioned image as latest
	docker tag $(IMAGE_NAME):$(VERSION) $(IMAGE_NAME):latest

push: ## Push Docker image to registry
	docker push $(IMAGE_NAME):$(VERSION)

push-latest: ## Push latest Docker image to registry
	docker push $(IMAGE_NAME):latest

push-all: build tag-latest push push-latest ## Build, tag, and push both versioned and latest images

clean: ## Remove local Docker images
	docker rmi $(IMAGE_NAME):$(VERSION) $(IMAGE_NAME):latest || true

# Development targets
dev-build: ## Build development image
	docker build -t $(IMAGE_NAME):dev -f $(DOCKERFILE) $(BUILD_CONTEXT)

# Show current image info
info: ## Show Docker image information
	@echo "Image: $(IMAGE_NAME)"
	@echo "Version: $(VERSION)"
	@echo "Dockerfile: $(DOCKERFILE)"
	@echo "Build context: $(BUILD_CONTEXT)"