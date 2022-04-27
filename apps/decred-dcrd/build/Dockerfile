# Build image using alpine
FROM golang:alpine as gobuild

ENV     DCRD_VERSION            v1.7.1
ENV     DCRCTL_VERSION          v1.7.1

RUN apk add --no-cache git

RUN git clone -b release-$DCRD_VERSION https://github.com/decred/dcrd.git \
    && cd dcrd/ \
    && go install . ./...

#build dcrctl
RUN     git clone -b release-$DCRCTL_VERSION https://github.com/decred/dcrctl.git\
        && cd dcrctl/ \
        && go install .

# Production image
FROM alpine:3.13.5

RUN apk add --no-cache bash ca-certificates
COPY --from=gobuild /go/bin/* /bin/

# add copy from config file to dcrdata
COPY    ./start-dcrd.sh /start-dcrd.sh
RUN     chmod +x /start-dcrd.sh && \
        mkdir -p /storage/dcrd && \
        mkdir /storage/logs