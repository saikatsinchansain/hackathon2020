#!/bin/bash
# Start Tessera nodes.

set -u
set -e

tesseraJar=/usr/local/bin/tessera-app-0.10.4-app.jar

#extract the tessera version from the jar
TESSERA_VERSION=$(unzip -p $tesseraJar META-INF/MANIFEST.MF | grep Tessera-Version | cut -d" " -f2)
echo "Tessera version (extracted from manifest file): $TESSERA_VERSION"

echo "[*] Starting Tessera node(s)"

currentDir=`pwd`

    DDIR="data/tessera"
    mkdir -p ${DDIR}
    mkdir -p data/logs
    rm -f "$DDIR/tm.ipc"


    #Only set heap size if not specified on command line
    MEMORY="-Xms128M -Xmx128M"

CMD="java  $MEMORY -jar ${tesseraJar} -configfile $DDIR/tessera-config.json"
echo "$CMD >> data/logs/tessera.log 2>&1 &"
${CMD} >> "data/logs/tessera.log" 2>&1 &
sleep 1


echo "Waiting until all Tessera nodes are running..."
DOWN=true
k=10
while ${DOWN}; do
    sleep 1
    DOWN=false
        if [ ! -S "data/tessera/tm.ipc" ]; then
            echo "Node is not yet listening on tm.ipc"
            DOWN=true
        fi

        set +e
        #NOTE: if using https, change the scheme
        #NOTE: if using the IP whitelist, change the host to an allowed host
        result=$(curl -s http://localhost:9000/upcheck)
        set -e
        if [ ! "${result}" == "I'm up!" ]; then
            echo "Node is not yet listening on http"
            DOWN=true
        fi

    k=$((k - 1))
    if [ ${k} -le 0 ]; then
        echo "Tessera is taking a long time to start.  Look at the Tessera logs in qdata/logs/ for help diagnosing the problem."
    fi
    echo "Waiting until all Tessera nodes are running..."

    sleep 5
done

echo "All Tessera nodes started"
exit 0
