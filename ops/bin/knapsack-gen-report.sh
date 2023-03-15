#!/bin/bash

set -e

bundle check || bundle install


echo "+++ generating minitest knapsack report"
RAILS_ENV=test KNAPSACK_GENERATE_REPORT=true bundle exec rake test



