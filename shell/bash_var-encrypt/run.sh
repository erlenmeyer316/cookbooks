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
SSL_PUB=$HOME/.config/public_key.pem
SSL_PRIV=$HOME/.config/private_key.pem

#
# generate the private ssl key
#

if [ -f $SSL_PRIV ]; then
    rm $SSL_PRIV
fi

openssl genrsa -out $SSL_PRIV 

#
# generate the public ssl key
#

if [ -f $SSL_PUB ]; then
    rm $SSL_PUB
fi

openssl rsa -in $SSL_PRIV -pubout -out $SSL_PUB  


#
# encrypt the var using the symetric key
#

MYVAR_ENC=$(echo "$MYVAR" | openssl pkeyutl -encrypt -pubin -inkey $SSL_PRIV)
echo "${MYVAR_ENC}"
#
# decrypt the var
#

#openssl pkeyutl -decrypt -inkey $SSL_PRIV -in $MYVAR_ENC

