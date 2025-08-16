#! /bin/bash
#
# /*
#  * Copyright (c) 2023  Bitshift D.O.O (http://bitshifted.co)
#  *
#  * This Source Code Form is subject to the terms of the Mozilla Public
#  * License, v. 2.0. If a copy of the MPL was not distributed with this
#  * file, You can obtain one at http://mozilla.org/MPL/2.0/.
#  */
#

PATCH_REGEX='^(build|chore|ci|docs|fix|perf|refactor|revert|style|test)\s?(\(.+\))?\s?:\s*(.+)'
MINOR_REGEX='^(feat)\s*(\(.+\))?\s?:\s*(.+)'
MAJOR_REGEX='^(BREAKING CHANGE)\s*(\(.+\))?\s?:\s*(.+)'

if [ "$1" = "--pull-request" ];then 
  git rev-parse --short HEAD
  exit 0
fi

# Check if --manual parameter if present
MANUAL=""
for ((i=1; i<=$#; i++)); do
  if [ "${!i}" = "--manual" ]; then
    next=$((i+1))
    MANUAL="${!next}"
    if [[ ! "$MANUAL" =~ ^(major|minor|patch)$ ]]; then
      echo "Error: --manual must be followed by one of: major, minor, patch" >&2
      exit 1
    fi
  fi
done

# get the latest tag
LATEST_TAG=$(git tag -l --sort=v:refname | grep -E  "[0-9]+\.[0-9]+\.[0-9]+$" | tail -n 1)
if [ -z $LATEST_TAG ]; then
  LATEST_TAG="$INPUT_INITIAL_VERSION"
  echo $LATEST_TAG
  exit 0
fi

LATEST_VERSION=""
if [[ $LATEST_TAG =~ [0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    LATEST_VERSION=${BASH_REMATCH[0]}
else
    echo "Failed to extract current version" >&2
    exit 1
fi

# process last commit message
MESSAGE=$(git log -1 --pretty=%B)
if [[ -z "$MANUAL" ]];then
  case "$MESSAGE" in
    $PATCH_REGEX)
      semver-bump.sh -p $LATEST_VERSION
      ;;
    $MINOR_REGEX)
      semver-bump.sh -m $LATEST_VERSION
      ;;
    $MAJOR_REGEX)
      semver-bump.sh -M $LATEST_VERSION
      ;;
    *)
      semver-bump.sh -p $LATEST_VERSION
      ;;
  esac
else
  case "$MANUAL" in
    patch)
      semver-bump.sh -p $LATEST_VERSION
      ;;
    minor)
      semver-bump.sh -m $LATEST_VERSION
      ;;
    major)
      semver-bump.sh -M $LATEST_VERSION
      ;;
    *)
      exit 1
      ;;
  esac
fi
