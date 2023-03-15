#!/bin/bash

set -e

bundle check || bundle install


bundle exec puma -C /app/ops/puma/puma.rb

