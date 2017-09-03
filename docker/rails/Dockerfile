FROM ruby:2.4.0
ENV LANG C.UTF-8
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN apt-get update -qq && apt-get install -y mysql-client
RUN gem install bundler
WORKDIR /tmp
ENV APP_HOME /productinfo_api
RUN mkdir -p $APP_HOME
ADD ./productinfo_api $APP_HOME
WORKDIR $APP_HOME
RUN bundle install --path vendor/bundle
