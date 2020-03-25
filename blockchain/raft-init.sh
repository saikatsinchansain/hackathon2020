#!/bin/bash
set -u
set -e

RAFT_PORT=50401
PORT=21000
HOST_IP=$(hostname -i)
echo $HOST_IP

echo "[*] Cleaning up temporary data directories"
rm -rf data
mkdir -p data/{keystore,geth,logs}

geth -datadir data account new -password passwords.txt
mv data/keystore/* data/keystore/key
bootnode -genkey nodekey
mv nodekey data/geth/nodekey
ENODE=$(bootnode -nodekey data/geth/nodekey -writeaddress)
cat <<EOF > data/static-nodes.json 
[
  "enode://$ENODE@$HOST_IP:$PORT?discport=0&raftport=$RAFT_PORT"
]
EOF
geth --datadir data init genesis.json

cat data/static-nodes.json

#Initialise Tessera configuration
#./tessera-init.sh

#Initialise Cakeshop configuration
#./cakeshop-init.sh
