#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

. ./gitlib.sh
. ./semvar.sh

# The following variables/secrets should be set on the host level
# These are created by genereating a deploy token with a username
# and the correct scopes in the GitLab repository settings.
# ============================================================
# GITLAB_PAT_USER - name.# used to authenticate and push source code
# GITLAB_PAT_TOKEN - project access token used to authenticate and push source code
# ============================================================
GITLAB_BUILD_BRANCH="dev"
GITLAB_PAT_USER="dickison.12"
GITLAB_PAT_TOKEN="FQcrxPByXyfQqiUqUQbm"
SCRIPT_DIR=$(dirname "$(realpath "$0")")
ROOT_DIR=$(dirname "$SCRIPT_DIR")
SKIP_CLEANUP="false"

####################
# SCRIPT VARIABLES #
####################

SOURCE_REPOSITORY=code.osu.edu/dickison.12/scripting-tests.git
WORKSPACE_ROOT="./tmp/workspace"
WORKSPACE_BUILD_DIR="${WORKSPACE_ROOT}/$(date -u +"%Y%m%d_%H%M%S")"

__trapError() {
	if [[ $? -eq 1 ]]; then
		echo "❌ Build failed!"
		_cleanUpBuildWorkspace ${WORKSPACE_BUILD_DIR}
	fi
}

trap '__trapError' EXIT

###############
# BUILD TASKS #
###############
_cleanUpBuildWorkspace() {
	local workspacePath=$1

	if [ -z "$workspacePath" ]; then
		workspacePath="$WORKSPACE_ROOT"
	fi

	if [ -d "${workspacePath}" ]; then
		if [ $SKIP_CLEANUP == "true" ]; then
			echo "❌ Skipping Cleanup!"
		else
			rm -rf "${workspacePath}"
		fi
	fi
}

_checkDependencies() {
	command -v git >/dev/null 2>&1 || {
		echo >&2 "git is required but it's not installed. Aborting."
		exit 1
	}
	command -v docker >/dev/null 2>&1 || {
		echo >&2 "docker is required but it's not installed. Aborting."
		exit 1
	}
}

_confirmEnvironmentVariables() {
	if [ -z "$GITLAB_PAT_USER" ]; then
		echo "❌ GITLAB_DEPLOY_USER environment variable is not set. Aborting."
		exit 1
	fi

	if [ -z "$GITLAB_PAT_TOKEN" ]; then
		echo "❌ GITLAB_DEPLOY_TOKEN environment variable is not set. Aborting."
		exit 1
	fi

	if [ -z "$GITLAB_BUILD_BRANCH" ]; then
		echo "❌ GITLAB_BUILD_BRANCH environment variable is not set. Aborting."
		exit 1
	fi

	if [ -z "$SOURCE_REPOSITORY" ]; then
		echo "❌ SOURCE_REPOSITORY environment variable is not set. Aborting."
		exit 1
	fi

}

_createBuildWorkspace() {
	local workspacePath=$1

	if [ -z "$workspacePath" ]; then
		echo "Usage: createBuildWorkspace <workspacePath>"
		exit 1
	fi

	if [ -d "${workspacePath}" ]; then
		_cleanUpBuildWorkspace "${workspacePath}"
	fi

	mkdir -p "${workspacePath}"
}


#################
#  BUILD STAGES #
#################
PRECHECK() {
	_checkDependencies
	_confirmEnvironmentVariables
}

CLONE() {
    gitlib_clone_repository $WORKSPACE_BUILD_DIR $GITLAB_PAT_TOKEN $SOURCE_REPOSITORY
}

BUILD() {
    if [ "$GITLAB_BUILD_BRANCH" == "main" ]; then 
        latestTestTag=$(gitlib_get_latest_tag_from_branch $WORKSPACE_BUILD_DIR "test")
        
    fi

    if [ "$GITLAB_BUILD_BRANCH" == "test" ]; then
        latestDevTag=$(gitlib_get_latest_tag_from_branch $WORKSPACE_BUILD_DIR "dev") 
    fi

    if [ "$GITLAB_BUILD_BRANCH" == "dev" ]; then 
        local latestProdTag=$(gitlib_get_latest_tag_from_branch $WORKSPACE_BUILD_DIR "main")
        echo "$latestProdTag from gitlib"

        if [ "$latestProdTag" == "none"]; then
            $latestProdTag = "0.0.0"
        fi

        local majorVersion=$(semver_parse_version $latestProdTag "major")
        local minorVersion=$(semver_parse_version $latestProdTag "minor")
        local patchVersion=$(semver_parse_version $latestProdTag "patch")

        echo "Major: $majorVersion"
        echo "Minor: $minorVersion"
        echo "Patch: $patchVersion"
    fi

    
	
}

CLEAN_UP() {
	_cleanUpBuildWorkspace $WORKSPACE_BUILD_DIR
}

#####################
# SCRIPT ENTRYPOINT #
#####################
PRECHECK
CLONE
BUILD
#CLEAN_UP