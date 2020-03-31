#!/usr/bin/env bash
# Initialise data for Tessera nodes.

echo "[*] Initialising Tessera configuration for $numNodes node(s)"

tesseraJar=/usr/local/bin/tessera-app-0.10.4-app.jar

# Write the config for the Tessera nodes
currentDir=$(pwd)


DDIR="${currentDir}/data/tessera"
mkdir -p ${DDIR}
mkdir -p data/logs
echo '' | java -jar ${tesseraJar} -keygen -filename ${DDIR}/tm

rm -f "${DDIR}/tm.ipc"

serverPortP2P=$((9000))
serverPortThirdParty=$((9080))
serverPortEnclave=$((9180))

#change tls to "strict" to enable it (don't forget to also change http -> https)
cat <<EOF > ${DDIR}/tessera-config.json
{
    "useWhiteList": false,
    "jdbc": {
        "username": "sa",
        "password": "",
        "url": "jdbc:h2:${DDIR}/db;MODE=Oracle;TRACE_LEVEL_SYSTEM_OUT=0",
        "autoCreateTables": true
    },
    "serverConfigs":[
        {
            "app":"ThirdParty",
            "enabled": true,
            "serverAddress": "http://$(hostname -i):${serverPortThirdParty}",
            "cors" : {
                "allowedMethods" : ["GET", "OPTIONS"],
                "allowedOrigins" : ["*"]
            },
            "communicationType" : "REST"
        },
        {
            "app":"Q2T",
            "enabled": true,
            "serverAddress":"unix:${DDIR}/tm.ipc",
            "communicationType" : "REST"
        },
        {
            "app":"P2P",
            "enabled": true,
            "serverAddress":"http://$(hostname -i):${serverPortP2P}",
            "sslConfig": {
                "tls": "OFF",
                "generateKeyStoreIfNotExisted": true,
                "serverKeyStore": "${DDIR}/server${i}-keystore",
                "serverKeyStorePassword": "quorum",
                "serverTrustStore": "${DDIR}/server-truststore",
                "serverTrustStorePassword": "quorum",
                "serverTrustMode": "TOFU",
                "knownClientsFile": "${DDIR}/knownClients",
                "clientKeyStore": "${DDIR}/client${i}-keystore",
                "clientKeyStorePassword": "quorum",
                "clientTrustStore": "${DDIR}/client-truststore",
                "clientTrustStorePassword": "quorum",
                "clientTrustMode": "TOFU",
                "knownServersFile": "${DDIR}/knownServers"
            },
            "communicationType" : "REST"
        }
    ],
    "peer": [ {
            "url": "http://172.31.37.80:9000/"
        }],
    "keys": {
        "passwords": [],
        "keyData": [
            {
                "privateKeyPath": "${DDIR}/tm.key",
                "publicKeyPath": "${DDIR}/tm.pub"
            }
        ]
    },
    "alwaysSendTo": []
}
EOF
