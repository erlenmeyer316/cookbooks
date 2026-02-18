#!/usr/bin/env bash

shopt -s nullglob


file_exists() {
   if [ -f "$1" ]; then
      return 0
   fi
   return 1
}

list_file_contents() {
    if file_exists "$1"; then
         cat -n "${1}"
    fi
}

in_array() {
  for i in "$PROFILE_DEPS[@]"
  do
     if [[ "$i" == "$1" ]]; then
        return 0
     fi
  done
  return 1
}

# script variables
PROFILE=""
PROFILE_DEPS=()
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
PROFILES=$(ls "${SCRIPT_DIR}/profiles")


 register_profile_deps() {
  if file_exists "${1}"; then
      echo "============================="
      echo "registering new dependencies"
      echo "============================="
      for dep in $(cat "$1")
      do
	ADD="1"
	echo "Dep: $dep"
	echo "Existing deps: ${PROFILE_DEPS[@]}"
	for exst in $PROFILE_DEPS[@]
	do
	  echo "Existing Dep: $exst"
	  #if [ "$dep" == "$exst" ]; then
	  if in_array $dep; then
	     ADD="0"
	  else 
	     ADD="1"
	  fi
	done
	if [ "$ADD" == "1" ]; then
	   echo "Adding $dep to tree"
	   PROFILE_DEPS+=("$dep")
	   register_profile_deps "${SCRIPT_DIR}/profiles/${dep}/profile.deps"
	fi
      done
   fi
}

install_profile() {
   register_profile_deps "${SCRIPT_DIR}/profiles/${1}/profile.deps"
   echo "Profile: $PROFILE"
   echo "Deps: ${PROFILE_DEPS[@]}"
}

PROFILE=${1}
install_profile "$PROFILE"

