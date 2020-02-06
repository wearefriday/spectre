#!/bin/bash

bundle exec rake db:schema:load
./script/server
