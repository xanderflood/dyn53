FROM alpine:3.9

COPY dyn53 /dyn53
COPY entrypoint.sh /entrypoint.sh

RUN mkdir -p /run/secrets

CMD ["/entrypoint.sh"]
