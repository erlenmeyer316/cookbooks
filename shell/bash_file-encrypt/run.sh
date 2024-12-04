#!/usr/bin/env bash

#
# file to encrypt
#
FILE=SecretMessage.txt
FILE_ENC=SecretMessage.txt.enc
FILE_DENC=SecretMessage.txt.denc

#
# ssh keys
#
SSH_PUB=$HOME/.ssh/id_ed25519.pub
SSH_PRIV=$HOME/.ssh/id_ed25519

#
# ssl key
#
SSL_PUB=$HOME/.config/public.key
SSL_PRIV=$HOME/.config/private.key

#
# generate the private ssl key
#
if [ -f $SSL_PRIV ]; then
    rm $SSL_PRIV
fi

openssl genrsa -out $SSL_PRIV 4096 

#
# generate the public ssl key
#
if [ -f $SSL_PUB ]; then
    rm $SSL_PUB
fi

openssl rsa -in $SSL_PRIV -pubout -out $SSL_PUB  


#
# encrypt he file using the symetric key
#
if [ -f $FILE_ENC ]; then
   rm $FILE_ENC
fi

openssl pkeyutl -encrypt -pubin -inkey $SSL_PUB -in $FILE -out $FILE_ENC  


#
# decrypt the encrypted symmetric key using the private ssh key
#

if [ -f $FILE_DENC ]; then
   rm $FILE_DENC
fi

openssl pkeyutl -decrypt -inkey $SSL_PRIV -in $FILE_ENC -out $FILE_DENC 
