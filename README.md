# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

Create Gemfile
	add source 'https://rubygems.org' 
	and gem 'rails'

create Gemfile.lock

create Dockerfile
example Dockerfile
	FROM ruby:2.4.1

	RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

	RUN mkdir /rails_docker
	WORKDIR /rails_docker


	ADD ./Gemfile /rails_docker/Gemfile
	ADD ./Gemfile.lock /rails_docker/Gemfile.lock
	RUN bundle install

	ADD . /rails_docker

create docker-compose.yml
example docker-comple.yml
	version: '2'
	services:
	  db:
	    image: mariadb:10.3.1
	    restart: always
	    environment:
	      MYSQL_ROOT_PASSWORD: password
	      MYSQL_DATABASE: rails_docker
	      MYSQL_USER: appuser
	      MYSQL_PASSWORD: password
	    ports:
	      - "3307:3306"  
	  app:
	    build: .
	    command: bundle exec rails s -p  3000 -b 0.0.0.0 
	    volumes:
	      - ".:/rails_docker"
	    ports:
	      - "3001:3000"  
	    depends_on:
	      - db
	    links:
	      - db
	    environment:
	      DB_USER: root
	      DB_NAME: rails_docker
	      DB_PASSWORD: password
	      DB_HOST: db

in terminal run
	docker-compose run app rails new . —force —database=mysql —skip-bundle
	docker-compose run -rm app rake db:create
	docker-compose build
	docker-compose up

You should have a basic hello world app on localhost:3000
	
