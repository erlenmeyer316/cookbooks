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
  IN_ARRAY=1
  for i in "$PROFILE_DEPS"
  do
     if [ "$i" == "$1" ]; then
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
  DEPS_FILE="${SCRIPT_DIR}/profiles/${1}/profile.deps"
  if file_exists "${DEPS_FILE}"; then
      for dep in $(cat "${DEPS_FILE}")
      do      
	add_dep=1
        for i in "${PROFILE_DEPS[@]}"
	do
	   if [ "$i" == "$dep" ]; then
	      add_dep=0
	   fi
	done
	if [ $add_dep -eq 1 ]; then
	   PROFILE_DEPS+=("${dep}")
	   install_profile $dep
	fi
      done
   fi
}

install_profile() {
   register_profile_deps ${1}
}

PROFILE=${1}
install_profile "$PROFILE"
echo "Profile: $PROFILE"
echo "Depends on: ${PROFILE_DEPS[@]}"


