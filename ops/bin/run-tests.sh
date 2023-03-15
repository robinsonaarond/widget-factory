#!/bin/bash

set -e


bundle exec rake db:test:prepare
RAILS_ENV=test bundle exec rails test "$@"

