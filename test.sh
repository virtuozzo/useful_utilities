#!/bin/bash

exit_code=0

echo "*** Running onapp-utils specs"
bundle install | grep Installing
bundle exec rake app:db:drop app:db:create app:db:migrate app:db:test:prepare
bundle exec rspec spec

exit_code+=$?

exit $exit_code
