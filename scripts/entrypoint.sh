#! /bin/bash


set -u # gives warning when using undeclared variables

echo "Github event name: $GITHUB_EVENT_NAME"
echo "Github event path:  $GITHUB_EVENT_PATH"

cat $GITHUB_EVENT_NAME

echo "::set-output name=version-string::1.2.3"

exit 0
