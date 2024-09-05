FROM golang:1.22.5-alpine3.20 AS builder

WORKDIR /app

COPY go.mod ./
RUN go mod download

COPY . .

RUN go build -o birdapi .

FROM alpine:latest

WORKDIR /app

COPY --from=builder /app/birdapi /app/

EXPOSE 4201

CMD ["./birdapi"]