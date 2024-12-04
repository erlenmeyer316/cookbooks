#!/usr/bin/env bash


MYVAR_ENC=$(echo "This is a simple string" | openssl enc -base64 -e -aes-256-cbc -salt -pass pass:SuperS3curePassw0rd! -pbkdf2)

MYVAR_DENC=$(echo "$MYVAR_ENC" | openssl enc -base64 -d -aes-256-cbc -salt -pass pass:SuperS3curePassw0rd! -pbkdf2)
