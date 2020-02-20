#!/bin/bash

RAILS_ENV=production bin/rake assets:precompile

./script/server
