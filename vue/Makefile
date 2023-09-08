# If you are using a different command, please customize it.
help: ## Display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
start: ## run start dev
	bash dnode.sh npm run dev
pack: ## build dist and package dist.tar.gz
	bash dnode.sh npm run build  && tar -czf dist.tar.gz dist
install: ## install node module
	bash dnode.sh npm install
unpack: ## run tar build.tar.gz
	rm -rf build/* && tar -zxf build.tar.gz

