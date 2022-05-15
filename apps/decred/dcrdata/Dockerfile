#build dcrdata from source using golang latest alpine
FROM    golang:alpine as gobuild
ENV     DCRDATA_VERSION     v5.2.0
RUN     apk add --no-cache git
RUN     git clone -b release-$DCRDATA_VERSION https://github.com/decred/dcrdata.git \
        && cd dcrdata/cmd/dcrdata \
        && env GO111MODULE=on go build -v

#build webassets required by dcrdata using node.js latest alpine
FROM    node:alpine3.11 as webassets
WORKDIR /root
COPY    --from=gobuild /go/src/github.com/decred/dcrdata/cmd/dcrdata /root
RUN     npm install -g npm@7.5.0
RUN     npm install
RUN     npm run build

#final dcrdata production image
FROM    alpine:3.13.5
RUN     apk add --no-cache bash ca-certificates

#copy binaries and webassets from build images
COPY    --from=gobuild /go/src/cmd/dcrdata/dcrdata /dcrdata
COPY    --from=gobuild /go/src/cmd/dcrdata/views /views
COPY    --from=webassets /root/public /public

#copy start script to producation image
COPY    ./start-dcrdata.sh /start-dcrdata.sh
RUN     chmod +x /start-dcrdata.sh

#create volume mount lcations
RUN     mkdir -p /storage/dcrdata && \
        mkdir -p /config/dcrdata