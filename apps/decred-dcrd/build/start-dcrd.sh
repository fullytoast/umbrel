#!/bin/bash
set -e

#checks to see if cert/key exist, creates if missinn
if [[ ! -f /storage/certs/dcrd.cert || ! -f /storage/certs/dcrd.key ]]; then
  gencerts -H=10.21.21.95 -f /storage/certs/dcrd.cert /storage/certs/dcrd.key
  echo "## Generating RPC certificate and key ###"
fi

# Set dcrd options
echo "## Start dcrd ##"
dcrd_options=(
  --datadir=/storage/dcrd
  --logdir=/storage/logs
  --rpccert=/storage/certs/dcrd.cert
  --rpckey=/storage/certs/dcrd.key
  --rpcuser=testuser
  --rpcpass=testpass
  --rpclisten=:9109
  --txindex
  --addrindex
)

dcrd "${dcrd_options[@]}"
