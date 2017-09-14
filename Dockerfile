FROM ruby:2.4.1

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev libssl-dev nodejs npm

RUN mkdir /rails_docker
WORKDIR /rails_docker

RUN npm cache clean -f 
RUN npm install -g n
RUN n stable
RUN npm install yarn

ADD ./Gemfile /rails_docker/Gemfile
ADD ./Gemfile.lock /rails_docker/Gemfile.lock
RUN bundle install

RUN bundle exec rails g simple_form:materialize:install

ADD . /rails_docker

