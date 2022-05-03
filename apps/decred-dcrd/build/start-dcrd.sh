#!/bin/bash
set -e

#checks to see if cert/key exist, creates if missinn
if [[ ! -f /storage/certs/dcrd.cert || ! -f /storage/certs/dcrd.key ]]; then
  gencerts -H=$APP_DECRED_DCRD_IP -f /storage/certs/dcrd.cert /storage/certs/dcrd.key
  echo "## RPC certificate and key not found, generating... ##\n"
fi

echo "## dcrd tor hidden service onion address ##"
echo "   $APP_HIDDEN_SERVICE\n"

# Set dcrd options
echo "## Starting dcrd... ##\n"
dcrd_options=(
  --datadir=/storage/dcrd
  --logdir=/storage/logs
  --rpccert=/storage/certs/dcrd.cert
  --rpckey=/storage/certs/dcrd.key
  --rpcuser=testuser
  --rpcpass=testpass
  --rpclisten=:$APP_DECRED_DCRD_RPC_PORT
  --txindex
  --addrindex
)
# add tor config options to dcrd

dcrd "${dcrd_options[@]}"
