# syntax=docker/dockerfile:1

ARG RUBY_VERSION=3.4.1
FROM ruby:$RUBY_VERSION-slim

WORKDIR /rails

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    libpq-dev && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

COPY Gemfile Gemfile.lock ./

RUN gem install bundler && \
    bundle config set path '/usr/local/bundle' && \
    bundle install

COPY . .

ENV RAILS_ENV="development"

EXPOSE 3000

CMD ["bin/rails", "server", "-b", "0.0.0.0"]
