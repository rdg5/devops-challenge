FROM golang:1.22.5-alpine3.20 AS builder

WORKDIR /app

COPY go.mod ./
RUN go mod download

COPY . .

RUN go build -o birdimageapi .

FROM alpine:latest

WORKDIR /app

COPY --from=builder /app/birdimageapi /app/

EXPOSE 4200

CMD ["./birdimageapi"]