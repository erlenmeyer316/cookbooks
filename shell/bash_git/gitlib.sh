
#!/usr/bin/env bash

# Check if git is available
if ! command -v git &>/dev/null; then
    printf '❌ This script requires git\n'
    exit 1
fi

# ---------------------------
# Get latest commit SHA from a branch
# ---------------------------
gitlib_get_latest_commit_sha_from_branch() {
    local repositoryPath="$1"
    local branchName="$2"

    if [ -z "$repositoryPath" ] || [ -z "$branchName" ]; then
        echo "Usage: gitlib_get_latest_commit_sha_from_branch <repositoryPath> <branchName>"
        return 1
    fi

    if [ ! -d "$repositoryPath/.git" ]; then
        echo "❌ ${repositoryPath} is not a valid git repository."
        return 1
    fi

    gitlib_checkout_branch "$repositoryPath" "$branchName"
    local latestCommitSha
    latestCommitSha=$(git -C "$repositoryPath" rev-parse --short HEAD)

    echo "${latestCommitSha:-none}"
}

# ---------------------------
# Get latest tag from a branch
# ---------------------------
gitlib_get_latest_tag_from_branch() {
    local repositoryPath="$1"
    local branchName="$2"

    if [ -z "$repositoryPath" ] || [ -z "$branchName" ]; then
        echo "Usage: gitlib_get_latest_tag_from_branch <repositoryPath> <branchName>"
        return 1
    fi

    if [ ! -d "$repositoryPath/.git" ]; then
        echo "❌ ${repositoryPath} is not a valid git repository."
        return 1
    fi

    gitlib_checkout_branch "$repositoryPath" "$branchName"
    git fetch --tags

    local latestTag
    if [ "$branchName" == "main" ]; then
        latestTag=$(git -C "$repositoryPath" describe --tags --abbrev=0 --match "[0-9]*.[0-9]*.[0-9]*" 2>/dev/null || echo "none")
    else
        latestTag=$(git -C "$repositoryPath" describe --tags --abbrev=0 --match "*-${branchName}" 2>/dev/null || echo "none")
    fi
    

    echo $latestTag
}

# ---------------------------
# Clone repository
# ---------------------------
gitlib_clone_repository() {
    local targetPath="$1"
    local token="$2"
    local repository="$3"

    if [ -z "$targetPath" ] || [ -z "$token" ] || [ -z "$repository" ]; then
        echo "Usage: gitlib_clone_repository <targetPath> <token> <repository>"
        return 1
    fi

    git clone "https://oauth2:${token}@${repository}" "$targetPath"
}

# ---------------------------
# Checkout branch
# ---------------------------
gitlib_checkout_branch() {
    local repositoryPath="$1"
    local branchName="$2"
    echo "checking out branch $2"
    if [ -z "$repositoryPath" ] || [ -z "$branchName" ]; then
        echo "Usage: gitlib_checkout_branch <repositoryPath> <branchName>"
        return 1
    fi

    if [ ! -d "$repositoryPath/.git" ]; then
        echo "❌ ${repositoryPath} is not a valid git repository."
        return 1
    fi

    git -C "$repositoryPath" fetch origin "$branchName" --quiet
    git -C "$repositoryPath" checkout "$branchName"  --quiet
}

# ---------------------------
# Commit changes
# ---------------------------
gitlib_commit_changes() {
    local repositoryPath="$1"
    local commitMessage="$2"

    if [ -z "$repositoryPath" ] || [ -z "$commitMessage" ]; then
        echo "Usage: gitlib_commit_changes <repositoryPath> <commitMessage>"
        return 1
    fi

    git -C "$repositoryPath" add .
    git -C "$repositoryPath" commit -m "$commitMessage"
}

# ---------------------------
# Push changes
# ---------------------------
gitlib_push_changes() {
    local repositoryPath="$1"
    local token="$2"

    if [ -z "$repositoryPath" ] || [ -z "$token" ]; then
        echo "Usage: gitlib_push_changes <repositoryPath> <token>"
        return 1
    fi

    git -C "$repositoryPath" push
}

# ---------------------------
# Pull latest changes
# ---------------------------
gitlib_pull_latest_changes() {
    local repositoryPath="$1"
    local token="$2"

    if [ -z "$repositoryPath" ] || [ -z "$token" ]; then
        echo "Usage: gitlib_pull_latest_changes <repositoryPath> <token>"
        return 1
    fi
    git -C "$repositoryPath" pull
}

# ---------------------------
# Create tag
# ---------------------------
gitlib_create_tag() {
    local repositoryPath="$1"
    local tag="$2"

    if [ -z "$repositoryPath" ] || [ -z "$tag" ]; then
        echo "Usage: gitlib_create_tag <repositoryPath> <tag>"
        return 1
    fi

    git -C "$repositoryPath" tag "$tag"
}

# ---------------------------
# Push tags
# ---------------------------
gitlib_push_tags() {
    local repositoryPath="$1"

    if [ -z "$repositoryPath" ]; then
        echo "Usage: gitlib_push_tags <repositoryPath>"
        return 1
    fi

    git -C "$repositoryPath" push --tags
}
