#!/bin/bash
set -u
set -e

function performValidation() {
    # Warn the user if chainId is same as Ethereum main net (see https://github.com/jpmorganchase/quorum/issues/487)
    genesisFile=$1
    NETWORK_ID=$(cat $genesisFile | tr -d '\r' | grep chainId | awk -F " " '{print $2}' | awk -F "," '{print $1}')

    if [ $NETWORK_ID -eq 1 ]
    then
        echo "  Quorum should not be run with a chainId of 1 (Ethereum mainnet)"
        echo "  please set the chainId in the $genesisFile to another value "
        echo "  1337 is the recommend ChainId for Geth private clients."
    fi

    # Check that the correct geth executable is on the path
    set +e
    if [ "`which geth`" == "" ]; then
        echo "ERROR: geth executable not found. Ensure that Quorum geth is on the path."
        exit -1
    else
        GETH_VERSION=`geth version |grep -i "Quorum Version"`
        if [ "$GETH_VERSION" == "" ]; then
            echo "ERROR: you appear to be running with upstream geth. Ensure that Quorum geth is on the PATH (before any other geth version)."
            exit -1
        fi
        echo "  Found geth: \"$GETH_VERSION\""
    fi
    set -e
}

privacyImpl=tessera

# Perform any necessary validation
performValidation genesis.json

mkdir -p data/logs

#if [ "$privacyImpl" == "tessera" ]; then
#  echo "[*] Starting Tessera nodes"
./tessera-start.sh 
#elif [ "$privacyImpl" == "tessera-remote" ]; then
#  echo "[*] Starting tessera nodes"
#  ./tessera-start-remote.sh ${tesseraOptions}
#else
#  echo "Unsupported privacy implementation: ${privacyImpl}"
#  usage
#fi

echo "[*] Starting Ethereum nodes with ChainID and NetworkId of $NETWORK_ID"
#QUORUM_GETH_ARGS=${QUORUM_GETH_ARGS:-}
#set -v
ARGS="--nodiscover --verbosity 3 --networkid $NETWORK_ID --raft --rpc --rpccorsdomain=* --rpcvhosts=* --rpcaddr 0.0.0.0 --rpcapi admin,eth,debug,miner,net,shh,txpool,personal,web3,quorum,raft,quorumPermission --emitcheckpoints --unlock 0 --password passwords.txt"

basePort=21000
baseRpcPort=22000
baseRaftPort=50401
port=$(($basePort))
rpcPort=$(($baseRpcPort))
raftPort=$(($baseRaftPort))
PRIVATE_CONFIG=data/tessera/tm.ipc nohup geth --datadir data ${ARGS} --raftport ${raftPort} --rpcport ${rpcPort} --port ${port} 2> data/logs/node.log &
    #qdata/c${i}/tm.ipc  nohup
#set +v

echo
echo "Nodes configured. See 'data/logs' for logs, and run e.g. 'geth attach 'http://$(hostname -i):$((baseRpcPort))'' to attach to the first Geth node."


exit 0
