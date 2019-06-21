.PHONY: all
all: build-deps build lint test

APP=go-instabot
ALL_PACKAGES=$(shell go list ./... | grep -v "vendor")
APP_EXECUTABLE="./out/$(APP)"
ENVIRONMENT="development"

clean:
	rm -f $(APP_EXECUTABLE)

setup:
	go get -u golang.org/x/lint/golint
	go get -u github.com/golang/dep/cmd/dep

build-deps:
	dep ensure

update-deps:
	dep ensure

compile:
	mkdir -p out/
	go build -o $(APP_EXECUTABLE)

build: build-deps compile lint

lint:
	@for p in $(ALL_PACKAGES); do \
		echo "==> Linting $$p"; \
		golint $$p | { grep -vwE "exported (var|function|method|type|const) \S+ should have comment" || true; } \
	done

test:
	go test $(ALL_PACKAGES) -p=1