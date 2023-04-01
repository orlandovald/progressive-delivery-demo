FROM golang:1.18-alpine as builder
WORKDIR /usr/src/app

COPY ./go/go.mod ./
RUN go mod download && go mod verify

COPY ./go/ .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-w -s"

FROM scratch
COPY --from=builder --chmod=777 /usr/src/app/rollout-demo /rollout-demo
COPY go/static /static

EXPOSE 8080

ARG error_chance=0
ENV ERROR_CHANCE=${error_chance}
 
CMD ["/rollout-demo"]
