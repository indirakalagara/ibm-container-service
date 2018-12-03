#!/bin/bash

if [ "${PWD##*/}" == "create" ]; then
    KUBECONFIG_FOLDER=${PWD}/../../kube-configs
elif [ "${PWD##*/}" == "scripts" ]; then
    KUBECONFIG_FOLDER=${PWD}/../kube-configs
else
    echo "Please run the script from 'scripts' or 'scripts/create' folder"
fi

echo "Preparing yaml for composer card create and import pod"
sed -e "s+%CONNPROFILE%+${CONN_PROFILE}+g" -e "s/%PEERADMINCARDNAME%/${PEERADMINCARDNAME}/g" -e "s/%PEERADMINUSERNAME%/${PEERADMINUSERNAME}/g" -e "s+%ADMINPUBKEY%+${ADMINPUBKEY}+g" -e "s|%ADMINPRIVATEKEY%|${ADMINPRIVATEKEY}|g" ${KUBECONFIG_FOLDER}/composer-card-import-base-util.yaml > ${KUBECONFIG_FOLDER}/composer-card-import-temp.yaml

echo "I will wait 5 seconds before continuing."
sleep 5


echo "Creating Composer Card Import pod"
echo "Running: kubectl create -f ${KUBECONFIG_FOLDER}/composer-card-import-temp.yaml"
kubectl create -f ${KUBECONFIG_FOLDER}/composer-card-import-temp.yaml

while [ "$(kubectl get pods composer-card-import-util | grep composer-card-import-util | awk '{print $3}')" != "Completed" ]; do
    echo "Waiting for Ccomposer-card-import-util  container to be Completed"
    sleep 1;
done

if [ "$(kubectl get pod composer-card-import-util | grep composer-card-import-util | awk '{print $3}')" == "Completed" ]; then
	echo "composer-card-import-util Completed Successfully"
fi

if [ "$(kubectl get pod composer-card-import-util | grep composer-card-import-util | awk '{print $3}')" != "Completed" ]; then
	echo "Import card failed Failed"
fi

echo "Deleting composer-card-import-util  pod"
echo "Running: kubectl delete -f ${KUBECONFIG_FOLDER}/composer-card-import-temp.yaml"
kubectl delete -f ${KUBECONFIG_FOLDER}/composer-card-import-temp.yaml

while [ "$(kubectl get svc | grep composer-card-import-util | wc -l | awk '{print $1}')" != "0" ]; do
	echo "Waiting for composer-card-import-util pod to be deleted"
	sleep 1;
done
