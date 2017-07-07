include settings.mk

.PHONY: all
all: clean build

.PHONY: build
build:
	@echo "Building image dmalczyk/$(IMAGE_NAME) ..."
	@docker build -t dmalczyk/$(IMAGE_NAME) . 
	@echo "Build finished"

.PHONY: clean
clean:
	#rm -rf kylo-jars