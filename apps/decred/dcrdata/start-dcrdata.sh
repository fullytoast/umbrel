#!/bin/bash
set -e

if ! [ -f /config/dcrd/dcrd.cert ]; then
  echo "## ERR: DCRD RPC cert not found ##########"
  exit 1
fi  

# Set permissions for bitcoind
echo "## Fetch onion name ######################"
dcrdata_onion=$(cat /tor/dcrdata/hostname)
echo "## $dcrdata_onion"
echo "## Start dcrdata #########################"
dcrdata_options=(
  --appdata=/
  --datadir=/storage/dcrdata
  --logdir=/storage/logs
  --dcrduser=testuser
  --dcrdpass=testpass
  --dcrdserv=172.16.1.2:9109
  --dcrdcert=/config/dcrd/dcrd.cert
  --apilisten=172.16.1.4
  --pg=true
  --pgdbname=dcrdatadb
  --pguser=dcrdata
  --pgpass=$dcrdbpass
  --onion-address=$dcrdata_onion
)

dcrdata "${dcrdata_options[@]}"