#! /bin/bash


set -u # gives warning when using undeclared variables

# fix error 'fatal: detected dubious ownership in repository at '/github/workspace'' in Github Action
sh -c "git config --global --add safe.directory $PWD"

VERSION_STRING="$INPUT_INITIAL_VERSION"
echo "main branch: $INPUT_MAIN_BRANCH"
echo "Github ref: $GITHUB_REF"


if [ "$GITHUB_EVENT_NAME" = "pull_request" ]; then
    VERSION_STRING=$(version.sh --pull-request)
elif [ "$GITHUB_EVENT_NAME" = "push" ]; then
    if [ "$GITHUB_REF" = "refs/heads/$INPUT_MAIN_BRANCH" ]; then
        VERSION_STRING=$(version.sh)
    else 
        echo "Push not on main branch"
    fi
fi

echo "version-string=$VERSION_STRING" >> "$GITHUB_OUTPUT"

exit 0
