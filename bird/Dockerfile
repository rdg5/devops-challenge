FROM golang:1.22.5-alpine3.20 AS builder

WORKDIR /app

COPY go.mod ./
RUN go mod download

COPY main.go .

RUN GOOS=linux go build -o birdapi -a -ldflags '-extldflags "-static"' .

FROM alpine:3.20

RUN addgroup -S birdapi && adduser -S birdapi -G birdapi

WORKDIR /app

COPY --from=builder /app/birdapi /app/

USER birdapi

EXPOSE 4201

HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
  CMD wget --spider --quiet http://localhost:4201/health || exit 1

CMD ["./birdapi"]
