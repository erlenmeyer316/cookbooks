#!/usr/bin/env bash

#
# var to encrypt
#
MYVAR="ThisIsMyPassword"
MYVAR_ENC=""
MYVAR_DENC=""

#
# ssl key
#
SSL_PUB=public.key
SSL_PRIV=private.key

#
# generate the private ssl key
#

if [ -f $SSL_PRIV ]; then
    rm $SSL_PRIV
fi

openssl genrsa -out "${SSL_PRIV}" 2048 

#
# generate the public ssl key
#

if [ -f $SSL_PUB ]; then
    rm $SSL_PUB
fi

openssl rsa -in "${SSL_PRIV}" -pubout -out "${SSL_PUB}"  


#
# encrypt the var using the symetric key
#

MYVAR_ENC=$(echo "$MYVAR" | openssl pkeyutl -encrypt -pubin -inkey $SSL_PUB | base64 )
echo "Encrypted variabled:"
echo "$MYVAR_ENC"

#
# decrypt the var
#
MYVAR_DENC=$(echo "$MYVAR_ENC" | base64 -d | openssl pkeyutl -decrypt -inkey "$SSL_PRIV")
echo "Decrypted variabled:"
echo "$MYVAR_DENC"

#openssl pkeyutl -decrypt -inkey $SSL_PRIV -in $MYVAR_ENC

