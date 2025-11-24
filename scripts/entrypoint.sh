#! /bin/bash


set -u # gives warning when using undeclared variables

# fix error 'fatal: detected dubious ownership in repository at '/github/workspace'' in Github Action
sh -c "git config --global --add safe.directory $PWD"

VERSION_STRING="$INPUT_INITIAL_VERSION"


if [ "$GITHUB_EVENT_NAME" = "pull_request" ]; then
    VERSION_STRING=$(version.sh --pull-request)
    echo "Pull request version string: $VERSION_STRING"
else
    if [ "$GITHUB_REF" = "refs/heads/$INPUT_MAIN_BRANCH" ]; then
        if [ -n "${INPUT_MANUAL_BUMP:-}" ]; then
            VERSION_STRING=$(version.sh --tag-prefix $INPUT_TAG_PREFIX  --manual "$INPUT_MANUAL_BUMP") || exit 1
        else
            VERSION_STRING=$(version.sh --tag-prefix $INPUT_TAG_PREFIX) || exit 1
        fi
    else
        echo "Push not on main branch"
        exit 0
    fi
    if [ "$INPUT_CREATE_TAG" = "true" ]; then
        echo "Creating tag $INPUT_TAG_PREFIX$VERSION_STRING"
        git tag  $INPUT_TAG_PREFIX$VERSION_STRING || exit 1
        git push origin --tags
    fi
fi

echo "version-string=$VERSION_STRING" >> "$GITHUB_OUTPUT"

exit 0
