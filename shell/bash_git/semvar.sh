
#!/usr/bin/env bash


semver_parse_version() {
    local version="$1"
    local returnVersion="$2"
    local major minor patch

    local cleanVersion="${version%%-*}"
    # Split by '.' and assign
    IFS='.' read -r major minor patch <<< "$cleanVersion"
    
    case "$returnVersion" in
        "major")
            echo $major
            return
            ;;
        "minor")
            echo $minor
            return
            ;;
        "patch")
            echo $patch
            return
            ;;
        *)
            echo "Invalid return version."
            exit 1
    esac
}