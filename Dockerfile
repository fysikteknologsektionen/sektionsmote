# Use the ruby version specified in Gemfile.lock
FROM ruby:2.7.2-alpine3.13 AS development
WORKDIR /usr/src/app

# Required by bundler
RUN apk add git 

# Required to build certain packages.
RUN apk add --no-cache make
RUN apk add build-base
RUN apk add postgresql-dev
RUN apk add shared-mime-info
RUN apk add nodejs

# Uppdate bundler to the version specified in Gemfile.lock
RUN gem install bundler:2.2.8

FROM development AS production

COPY . /usr/src/app/
RUN bundle install

EXPOSE 3000
CMD ruby ./bin/setup && bundle exec rails server -b 0.0.0.0
