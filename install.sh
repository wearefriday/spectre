#!/bin/bash

RAILS_ENV=production bin/rake assets:precompile

bundle exec rake db:schema:load

./script/server
