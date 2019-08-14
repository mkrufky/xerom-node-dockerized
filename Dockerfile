# Build Geth in a stock Go builder container
FROM golang:1.12-alpine as builder

RUN apk add --no-cache make gcc musl-dev linux-headers git

WORKDIR /
RUN git clone https://github.com/xero-official/go-xerom.git && cd /go-xerom && make && cp -a /go-xerom/build/bin/geth /usr/local/bin/ && cd / && rm -rf /go-xerom

# Pull Geth into a second stage deploy alpine container
FROM alpine:latest

RUN apk add --no-cache ca-certificates
COPY --from=builder /usr/local/bin/geth /usr/local/bin/geth-xerom

EXPOSE 30305 30305/udp
ENTRYPOINT ["geth-xerom"]