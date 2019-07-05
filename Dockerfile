FROM alpine:3.9

RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*

COPY dyn53 /dyn53
COPY entrypoint.sh /entrypoint.sh

RUN mkdir -p /run/secrets

CMD ["/entrypoint.sh"]
