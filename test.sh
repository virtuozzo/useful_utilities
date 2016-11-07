#!/bin/bash

echo "*** Running onapp-utils specs"

bundle install                                      || exit 1
bundle exec rake app:db:drop app:db:create          || exit 1
bundle exec rake app:db:migrate app:db:test:prepare || exit 1
bundle exec rspec spec                              || exit 1
