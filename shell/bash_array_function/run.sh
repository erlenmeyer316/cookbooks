#!/usr/bin/env bash

update_array() {
  local -n arr=$1
  arr+=("sixteen" 0)
}

create_array() {
  local -n arr=$1
  arr=(one "two three" four)
}

use_array() {
  local my_array
  create_array my_array
  echo "create"
  declare -p my_array
  update_array my_array
  echo "update"
  declare -p my_array
}

use_array
