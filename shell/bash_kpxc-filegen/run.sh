#/usr/bin/env bash

if [ -f .env ]; then
    set -a; source .env; set +a;
    
    export KPXC_VAULT="${VAULT}"
    export KPXC_PASSWORD="${PASSWORD}"

    unset VAULT
    unset PASSWORD
fi 


PW=$(echo "${KPXC_PASSWORD}" | keepassxc-cli show -qsa password "${KPXC_VAULT}" "KeepassXC WebDAV")
USER=$(echo "${KPXC_PASSWORD}" | keepassxc-cli show -qsa username "${KPXC_VAULT}" "KeepassXC WebDAV")
URL=$(echo "${KPXC_PASSWORD}" | keepassxc-cli show -qsa url "${KPXC_VAULT}" "KeepassXC WebDAV")

printf "${URL}		${USER} ${PW}" > secretfile
