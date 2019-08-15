# Build Geth in a stock Go builder container
FROM golang:1.12-alpine as builder

RUN apk add --no-cache make gcc musl-dev linux-headers git

WORKDIR /
COPY . /go-xerom
RUN cd /go-xerom && make && cp -a /go-xerom/build/bin/geth /usr/local/bin/ && cd / && rm -rf /go-xerom

# Pull Geth into a second stage deploy alpine container
FROM alpine:latest

RUN apk add --no-cache ca-certificates
COPY --from=builder /usr/local/bin/geth /usr/local/bin/geth-xerom

EXPOSE 30307 30307/udp
ENTRYPOINT ["geth-xerom"]
CMD ["--syncmode=fast", "--cache=512", "--port=30307"]
