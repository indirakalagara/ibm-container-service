#!/bin/bash

if [ "${PWD##*/}" == "create" ]; then
	:
elif [ "${PWD##*/}" == "scripts" ]; then
	:
else
    echo "Please run the script from 'scripts' or 'scripts/create' folder"
		exit
fi

echo "clearing all old pods"
#./delete_all.sh

echo ""
echo "=> CREATE_ALL: Creating storage"
create/create_storage.sh $@

echo ""
echo "=> CREATE_ALL: Creating blockchain"
create/create_blockchain.sh $@

echo ""
echo "=> CREATE_ALL: Running Create Channel"
PEER_MSPID="Org1MSP" CHANNEL_NAME="composerchannel" create/create_channel.sh

echo ""
echo "=> CREATE_ALL: Running Join Channel on Org1 Peer1"
CHANNEL_NAME="composerchannel" PEER_MSPID="Org1MSP" PEER_ADDRESS="blockchain-org1peer1:30110" MSP_CONFIGPATH="/shared/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" create/join_channel.sh

echo "=> CREATE_ALL: Running Join Channel on Org2 Peer1"
CHANNEL_NAME="composerchannel" PEER_MSPID="Org2MSP" PEER_ADDRESS="blockchain-org2peer1:30210" MSP_CONFIGPATH="/shared/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp" create/join_channel.sh

echo "=> CREATE_ALL: Running Join Channel on Org3 Peer1"
CHANNEL_NAME="composerchannel" PEER_MSPID="Org3MSP" PEER_ADDRESS="blockchain-org3peer1:30310" MSP_CONFIGPATH="/shared/crypto-config/peerOrganizations/org3.example.com/users/Admin@org3.example.com/msp" create/join_channel.sh

echo ""
echo "=> CREATE_ALL: Create composer card and import for Org1"
CONN_PROFILE=/shared/config/org1connection.json PEERADMINCARDNAME=Org1PeerAdmin1.card PEERADMINUSERNAME=Org1PeerAdmin1 ADMINPUBKEY=/shared/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/signcerts/Admin@org1.example.com-cert.pem ADMINPRIVATEKEY=/shared/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/keystore/key.pem ./create/composer-card-import.sh 

echo ""
echo "=> CREATE_ALL: Create composer card and import for Org2"
CONN_PROFILE=/shared/config/org2connection.json PEERADMINCARDNAME=Org2PeerAdmin1.card PEERADMINUSERNAME=Org2PeerAdmin1 ADMINPUBKEY=/shared/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp/signcerts/Admin@org2.example.com-cert.pem ADMINPRIVATEKEY=/shared/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp/keystore/key.pem ./create/composer-card-import.sh 

echo ""
echo "=> CREATE_ALL: Create composer card and import for Org3"
CONN_PROFILE=/shared/config/org3connection.json PEERADMINCARDNAME=Org3PeerAdmin1.card PEERADMINUSERNAME=Org3PeerAdmin1 ADMINPUBKEY=/shared/crypto-config/peerOrganizations/org3.example.com/users/Admin@org3.example.com/msp/signcerts/Admin@org3.example.com-cert.pem ADMINPRIVATEKEY=/shared/crypto-config/peerOrganizations/org3.example.com/users/Admin@org3.example.com/msp/keystore/key.pem ./create/composer-card-import.sh 

echo ""
echo "=> CREATE_ALL: Creating composer playground"
create/create_composer-playground.sh $@

# Can't create this until the user has performed manual actions in the Composer Playground.
# echo ""
# echo "=> CREATE_ALL: Creating composer rest server"
# create/create_composer-rest-server.sh $@

echo ""
echo "=> CREATE_ALL: Running Install Chaincode on Org1 Peer1"
CHAINCODE_NAME="chaincode_example02" CHAINCODE_VERSION="v1" MSP_CONFIGPATH="/shared/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp"  PEER_MSPID="Org1MSP" PEER_ADDRESS="blockchain-org1peer1:30110" create/chaincode_install.sh

echo ""
echo "=> CREATE_ALL: Running Install Chaincode on Org2 Peer1"
CHAINCODE_NAME="chaincode_example02" CHAINCODE_VERSION="v1" MSP_CONFIGPATH="/shared/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp"  PEER_MSPID="Org2MSP" PEER_ADDRESS="blockchain-org2peer1:30210" create/chaincode_install.sh

echo ""
echo "=> CREATE_ALL: Running Install Chaincode on Org3 Peer1"
CHAINCODE_NAME="chaincode_example02" CHAINCODE_VERSION="v1" MSP_CONFIGPATH="/shared/crypto-config/peerOrganizations/org3.example.com/users/Admin@org3.example.com/msp"  PEER_MSPID="Org3MSP" PEER_ADDRESS="blockchain-org3peer1:30310" create/chaincode_install.sh


echo ""
echo "=> CREATE_ALL: Running instantiate chaincode on channel \"composerchannel\" using \"Org1MSP\""
CHANNEL_NAME="composerchannel" CHAINCODE_NAME="chaincode_example02" CHAINCODE_VERSION="v1" MSP_CONFIGPATH="/shared/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp"  PEER_MSPID="Org1MSP" PEER_ADDRESS="blockchain-org1peer1:30110" create/chaincode_instantiate.sh
