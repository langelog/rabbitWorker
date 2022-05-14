include .env.dev
include .env.secrets
export

.PHONY: dev
dev:
	docker compose up --build

.PHONY: release
release:
	docker build . --target release --tag ${PRODUCT}/${SERVICE}:${VERSION}r
	@echo "-----------------------"
	@echo "The release for service ${SERVICE} has been generated for version ${VERSION}"

.PHONY: test-run
test-run:
	docker run -it --rm \
	--name ${SERVICE} \
	-e QUEUE_USER=${QUEUE_USER} \
	-e QUEUE_PASS=${QUEUE_PASS} \
	-e QUEUE_HOST=${QUEUE_HOST} \
	--network ${DEV_NETWORK} \
	-d \
	${PRODUCT}/${SERVICE}:${VERSION}r

.PHONY: test
test:
	docker build . --target tester --tag ${PRODUCT}/${SERVICE}:${VERSION}t
	docker run -it --rm \
		--name ${SERVICE}_tester \
		-e QUEUE_USER=${QUEUE_USER} \
		-e QUEUE_PASS=${QUEUE_PASS} \
		-e QUEUE_HOST=${QUEUE_HOST} \
		-v ${PWD}/tests:/app \
		--network ${DEV_NETWORK} \
		${PRODUCT}/${SERVICE}:${VERSION}t
