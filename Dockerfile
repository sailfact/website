# Base Image
FROM ruby:3.4.7-bookworm

# System Dependencies
RUN apk add --no-cache build-base postgresql-client tzdata sqlite-libs sqlite-dev nodejs yarn git

# App directory
WORKDIR /App

# Gems
COPY Gemfile Gemfile.lock ./
RUN bundle config set deployment 'true' \
&& bundle config set deployment 'true' \
 && bundle config set without 'development test' \
 && bundle install --jobs 4

 # App
COPY . .

# Assets (importmap keeps this minimal)
ENV RAILS_ENV=production
RUN bundle exec rake assets:precompile

# Runtime
EXPOSE 3000
CMD ["bundle","exec","puma","-C","config/puma.rb"]