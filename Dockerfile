FROM ruby:2.3
RUN mkdir /app
WORKDIR /app
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN bundle install
ADD . /app