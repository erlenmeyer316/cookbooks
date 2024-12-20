#/usr/bin/env bash

if [ -f .env ]; then
  set -a
  source .env
  set +a

  export KPXC_VAULT="${VAULT}"
  export KPXC_PASSWORD="${PASSWORD}"

  unset VAULT
  unset PASSWORD
fi

PW=$(keepassxc-cli show -sa password "${KPXC_VAULT}" "google.com")
echo "This is the google.com secret: ${PW}"
