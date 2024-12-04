#/usr/bin/env bash

if [ -f .env ]; then
    set -a; source .env; set +a;
    
    echo ".env vault location: ${VAULT}"
    echo ".env vault password: ${PASSWORD}"

    export KPXC_VAULT="${VAULT}"
    export KPXC_PASSWORD="${PASSWORD}"

    unset VAULT
    unset PASSWORD

    rm .env
fi 

echo ".env vault location: ${VAULT}"
echo ".env vault password: ${PASSWORD}"

echo "ENV vault location: ${KPXC_VAULT}"
echo "ENV vault password: ${KPXC_PASSWORD}"

echo "${KPXC_PASSWORD}" | keepassxc-cli show -qsa password "${KPXC_VAULT}" google.com 

source subtask.sh
