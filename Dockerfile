FROM golang:1.13-alpine3.10 AS builder
COPY ./ /build
WORKDIR /build
RUN go build -v -mod=vendor

FROM alpine:3.10
RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*
COPY --from=builder /build/dyn53 /dyn53

ENTRYPOINT ["dyn53"]
