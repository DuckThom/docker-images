FROM alpine:latest

RUN apk update \
 && apk add openssh-client

RUN mkdir /app
COPY docker-entrypoint.sh /app

ENTRYPOINT ["sh", "/app/docker-entrypoint.sh"]
