FROM golang:1.22.5-alpine3.20 AS builder

WORKDIR /app

COPY go.mod ./
RUN go mod download

COPY main.go .

RUN CGO_ENABLED=0 GOOS=linux go build -o birdimageapi -a -ldflags '-extldflags "-static"' .

FROM alpine:3.20

RUN addgroup -S birdimageapi && adduser -S birdimageapi -G birdimageapi

WORKDIR /app

COPY --from=builder /app/birdimageapi /app/

USER birdimageapi

EXPOSE 4200

HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
  CMD wget --spider --quiet http://localhost:4201/health || exit 1

CMD ["./birdimageapi"]
