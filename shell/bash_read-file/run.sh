#!/usr/bin/env bash

filename='input.txt'

echo "Start"
while read -r line; do
  echo "$line"
done <"$filename"
