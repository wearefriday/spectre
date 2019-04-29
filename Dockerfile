FROM ruby:2.5.3

WORKDIR /opt
RUN curl -Ls https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 | tar -jxf -
RUN apt-get -qq update && apt-get -qq install fontconfig
RUN ln -s /opt/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin/

WORKDIR /app
ADD Gemfile* /app/
RUN gem install bundler && bundle config build.nokogiri --use-system-libraries && bundle install --quiet --jobs 16 --retry 5 --without test
RUN bundle install

ADD . /app

EXPOSE 3000
CMD ["script/server"]
