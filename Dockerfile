FROM golang:1.25-alpine3.23 AS builder

WORKDIR /app

COPY go.mod ./
COPY main.go ./
RUN go build -o goserver
ENTRYPOINT ["./goserver"]

#FROM alpine:latest
#
#WORKDIR /app
#
#COPY --from=builder /app/goserver .
#RUN chmod +x goserver
#
#ENTRYPOINT ["./goserver"]
