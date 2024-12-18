#/usr/bin/env bash
echo "posteo.net secret"
echo "${KPXC_PASSWORD}" | keepassxc-cli show -qsa password "${KPXC_VAULT}" posteo.net 
