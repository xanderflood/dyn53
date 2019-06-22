FROM alpine:3.9

RUN apk add --no-cache curl python py-pip
RUN pip install awscli --upgrade --user
RUN mv /root/.local/bin/* /usr/local/bin
RUN apk -v --purge del py-pip
RUN curl -L https://github.com/sequenceiq/docker-alpine-dig/releases/download/v9.10.2/dig.tgz|tar -xzv -C /usr/local/bin/

COPY update-record.sh /update-record.sh
COPY entrypoint.sh /entrypoint.sh

RUN mkdir -p /run/secrets

CMD ["/entrypoint.sh"]

