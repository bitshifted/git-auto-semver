#! /bin/bash


set -u # gives warning when using undeclared variables

VERSION_STRING="1.0.0"

echo "Github event name: $GITHUB_EVENT_NAME"
echo "Github event path:  $GITHUB_EVENT_PATH"

cat $GITHUB_EVENT_PATH


if [ "$GITHUB_EVENT_NAME" = "pull_request" ]; then
    VERSION_STRING=$(version.sh --pull-request)
fi

echo "Calculated version: $VERSION_STRING"
echo "version-string=$VERSION_STRING" >> "$GITHUB_OUTPUT"

exit 0
