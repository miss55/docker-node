# If you are using a different command, please customize it.
help: ## Display this help screen
		@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
install: ## run yarn install
		bash dnode.sh yarn install
start: ## run yarn start
		bash dnode.sh yarn start
pack: ## run yarn build and tar build.tar.gz
		bash dnode.sh yarn build && tar -czf build.tar.gz build
unpack: ## run tar build.tar.gz
		rm -rf build/* && tar -zxf build.tar.gz
