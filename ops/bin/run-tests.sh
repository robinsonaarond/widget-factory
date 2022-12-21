#!/bin/bash

set -e

echo "--- db setup"
echo "+++ tests ${CI_NODE_INDEX}"
bundle exec rails test TESTOPTS="--junit --junit-filename=log/tests-${BUILDKITE_JOB_ID}.xml"

