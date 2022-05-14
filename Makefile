include .env.dev
export

.PHONY: dev
dev:
	docker build . --target dev --tag ${PRODUCT}/${SERVICE}:${VERSION}
	docker run -it --rm -v ${PWD}/service:/app/service ${PRODUCT}/${SERVICE}:${VERSION}

#.PHONY: build
#build:
#	docker build . --target compiler --tag ${PRODUCT}/${SERVICE}:${VERSION}