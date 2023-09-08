
NODE_VERSION?=20.6.0-alpine3.18
IMAGE_NAME?=jenson/node-20.6

help: ## Display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
add: ## add image, you should: make add or make add NODE_VERSION=20.6.0-alpine3.18 IMAGE_NAME=jenson/node-20.6
	docker build . --build-arg NODE_VERSION=${NODE_VERSION} -t ${IMAGE_NAME}
show: ## print docker build command, you should: make show or make show NODE_VERSION=20.6.0-alpine3.18 IMAGE_NAME=jenson/node-20.6
	@echo " docker build . --build-arg NODE_VERSION=${NODE_VERSION} -t ${IMAGE_NAME} "
show_images: ## show docker node images
	docker images | grep "jenson/node"
