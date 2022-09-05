FROM golang:1.18-alpine as builder

WORKDIR /usr/src/app

# pre-copy/cache go.mod for pre-downloading dependencies and only redownloading them in subsequent builds if they change
COPY ./go/go.mod ./
RUN go mod download && go mod verify

COPY ./go/ .
RUN go build -v

FROM alpine:3.16
COPY --from=builder /usr/src/app/rollout-demo /usr/local/bin/rollout-demo

EXPOSE 8080

ARG error_rate=0
ENV ERROR_RATE=${error_rate}

CMD ["rollout-demo"]
