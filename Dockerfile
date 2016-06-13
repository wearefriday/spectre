FROM ruby:2.3
RUN mkdir /app
WORKDIR /app
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN bundle install
ADD . /app

CMD ["rails","s","-b","0.0.0.0"]