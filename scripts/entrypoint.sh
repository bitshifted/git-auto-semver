#! /bin/bash


set -u # gives warning when using undeclared variables

# fix error 'fatal: detected dubious ownership in repository at '/github/workspace'' in Github Action
sh -c "git config --global --add safe.directory $PWD"

echo "Initial version: $INPUT_INITIAL_VERSION"
VERSION_STRING="1.0.0"

echo "Github event name: $GITHUB_EVENT_NAME"
echo "Github event path:  $GITHUB_EVENT_PATH"

cat $GITHUB_EVENT_PATH


if [ "$GITHUB_EVENT_NAME" = "pull_request" ]; then
    VERSION_STRING=$(version.sh --pull-request)
elif [ "$GITHUB_EVENT_NAME" = "push"]
    VERSION_STRING=$(version.sh)
fi

echo "Calculated version: $VERSION_STRING"
echo "version-string=$VERSION_STRING" >> "$GITHUB_OUTPUT"

exit 0
