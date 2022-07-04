FROM golang:1.18-alpine3.16 AS builder

ENV CGO_ENABLED=0
ENV GOOS=linux

WORKDIR /app
COPY config.go go.mod go.sum net.go routine.go wireguard.go /app/
COPY cmd /app/cmd

ARG http_proxy
ARG https_proxy
ARG HTTP_PROXY
ARG HTTPS_PROXY
ARG no_proxy
ARG NO_PROXY

RUN set -ev ; \
    go mod tidy ; \
    go install ./cmd/wireproxy

FROM alpine:3.16 AS final

RUN apk upgrade
COPY --from=builder /go/bin/wireproxy /usr/bin/wireproxy

VOLUME ["/etc/wireproxy"]
ENTRYPOINT ["wireproxy", "--config", "/etc/wireproxy/config"]
