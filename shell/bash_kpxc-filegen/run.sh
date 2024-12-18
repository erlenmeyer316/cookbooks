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
MNT=$(echo "${KPXC_PASSWORD}" | keepassxc-cli show -qsa mountpoint "${KPXC_VAULT}" "KeepassXC WebDAV")
FS=$(echo "${KPXC_PASSWORD}" | keepassxc-cli show -qsa filesystem "${KPXC_VAULT}" "KeepassXC WebDAV")
OPTS=$(echo "${KPXC_PASSWORD}" | keepassxc-cli show -qsa options "${KPXC_VAULT}" "KeepassXC WebDAV")
DUMP=$(echo "${KPXC_PASSWORD}" | keepassxc-cli show -qsa dump "${KPXC_VAULT}" "KeepassXC WebDAV")
FSCK=$(echo "${KPXC_PASSWORD}" | keepassxc-cli show -qsa fsck "${KPXC_VAULT}" "KeepassXC WebDAV")

if [ -f secretfile ]; then
   rm secretfile
fi
printf "${URL}		${USER} ${PW}" > secretfile

if [ -f fstab ]; then
   rm fstab
fi

printf "${URL} ${MNT} ${FS} ${OPTS} ${DUMP} ${FSCK}" > fstab
