!/bin/bash
set -e

#checks to see if cert/key exist, creates if missinn
if [[ ! -f /config/dcrd.cert || ! -f /config/dcrd.key ]]; then
  gencerts -H=10.21.21.95 -f /storage/dcrd.cert /storage/dcrd.key
  echo "## Generating RPC certificate and key ###"
fi

# Set dcrd options
echo "## Start dcrd ##"
dcrd_options=(
  --datadir=/storage/dcrd
  --logdir=/storage/logs
  --rpccert=/storage/dcrd.cert
  --rpckey=/storage/dcrd.key
  --rpcuser=testuser
  --rpcpass=testpass
  --rpclisten=:9109
  --txindex
  --addrindex
)

dcrd "${dcrd_options[@]}"
