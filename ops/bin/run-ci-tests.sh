#!/bin/bash

set -e


bundle exec rake db:test:prepare
echo "+++ running tests"
bundle exec rake knapsack:minitest TESTOPTS="--junit --junit-filename=log/tests-${BUILDKITE_JOB_ID}.xml"

