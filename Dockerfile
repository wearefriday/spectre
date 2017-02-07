FROM ruby:2.3

WORKDIR /app

ADD Gemfile* /app/

RUN gem install bundler && bundle config build.nokogiri --use-system-libraries && bundle install --jobs 16 --retry 5 --without development test

ADD . /app

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
