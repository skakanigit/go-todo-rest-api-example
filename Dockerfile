FROM golang:1.23.6-alpine3.21 AS builder
RUN apk update && apk add --no-cache git tzdata bash alpine-sdk

ENV USER=appuser

RUN adduser --system -s /sbin/nologin $USER

COPY . /go-todo-rest-api-example

WORKDIR /go-todo-rest-api-example

RUN make build-local

FROM scratch 

COPY --from=builder /go-todo-rest-api-example/bin/rest-server opt/go-todo-rest-api-example/
COPY --from=builder /etc/passwd /etc/passwd

USER ${USER}:${USER}

WORKDIR /opt/go-todo-rest-api-example/

ENTRYPOINT [ "./rest-server" ]