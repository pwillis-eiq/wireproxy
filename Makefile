DOCKER_IMG := wireproxy:latest

all: mod build

docker-build:
	set -x; docker build -t $(DOCKER_IMG) \
	--build-arg="http_proxy=$$http_proxy" \
	--build-arg="https_proxy=$$https_proxy" \
	--build-arg="HTTP_PROXY=$$HTTP_PROXY" \
	--build-arg="HTTPS_PROXY=$$HTTPS_PROXY" \
	--build-arg="no_proxy=$$no_proxy" \
	--build-arg="NO_PROXY=$$NO_PROXY" \
	.

mod:
	go mod tidy

build:
	for os in darwin ; do \
	    for arch in arm64 ; do \
            GOOS=$${os} GOARCH=$${arch} go build -o wireproxy_$${os}_$${arch} ./cmd/wireproxy ; \
            chmod 755 wireproxy_$${os}_$${arch} ; \
        done ; \
    done
