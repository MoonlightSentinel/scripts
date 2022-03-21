#!/bin/bash

# Calculates the next tags in SemVer format based of the latest tag
#
# Usage: ./next_semver_tag.sh [major|minor|patch]
#
# Environment variables:
#  - SUFFIX: Custom new suffix
#  - KEEP_SUFFIX: Keep existing suffix if found

set -eu

CUR="$(git describe --tags $(git rev-list --tags --max-count=1))"

[[ "$CUR" =~ ^([^0-9]*)([0-9]+)\.([0-9]+)\.([0-9]+)([+-].+)?$ ]]

PREFIX="${BASH_REMATCH[1]}"
MAJOR="${BASH_REMATCH[2]}"
MINOR="${BASH_REMATCH[3]}"
PATCH="${BASH_REMATCH[4]}"

if [ -z ${SUFFIX+x} ]
then
    if [ "${KEEP_SUFFIX:-0}" != "0" ]
    then
        SUFFIX="${BASH_REMATCH[5]:-}"
    else
        SUFFIX=""
    fi
fi

KIND="${1:-}"
case "$KIND" in
    "major")
        MAJOR=$(( $MAJOR + 1 ))
        MINOR=0
        PATCH=0
        ;;

    "minor")
        MINOR=$(( $MINOR + 1 ))
        PATCH=0
        ;;

    "patch")
        PATCH=$(( $PATCH + 1 ))
        ;;

    *)
        echo "Unexpected release kind: '$KIND'"
        echo "Expected 'major', 'minor' or 'patch'"
        exit 1
        ;;
esac

echo "$PREFIX$MAJOR.$MINOR.$PATCH$SUFFIX"
