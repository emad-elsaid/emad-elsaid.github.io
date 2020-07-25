---
title: Deploy rails application with docker compose and capistrano
date: 2016-05-31T17:57:18+02:00
---

## What do we have?

In this article I will assume we have a ruby on rails application that is using a database to store some data, and capistrano for deployment and you want to deploy in on your server but instead of deploying directly on your server you want to dockerize the whole project to give it a separate environment and keep it away from your other applications.

## Why do we dockerize a rails application?

Being here probably you already know, docker is a good way to separate give your application a separate environement to work on, you can limit resources and limit access to filesystem, also using docker means your server reuquirements is only the `Dockerfile` and on your server you don't need anything axcept `git` and `docker` installed, this makes it easier for your to destroy the whole server and you still can get it up by a single command `docker-compose up` as long as you have your data volumes in place.

Also for dockerized applications it is easier to migrate to other server, you'll need to move your data directories or data volumes to the same path on the new server and then execute `docker-compose up` on the new server and your whole stack of application and database and any other services is up at an instance.

## Application requirements

Lets make this tutorial as simple as possible, let's assume we have a rails application, and it needs a postgres server, nothing else, no background jobs, no redis, no elasticsearch, actually after this tutorial it will be easier for you to add these services to the stack without much effort.

## Dockerizing the application

first we'll need to add a `Dockerfile` for your application, a `Dockerfile` is a file which contain your configuration for how to prepare a machine for your application and how to run the main process, and it should depend on a base image, you should use the nearest base image to your requirements, for me I found the ruby official image suitable and it has 3 variats i used the smallest one `ruby:slim`

So we'll do the following:

1. use ruby slim image
2. specify a locale for the image (this is optional but it removes a lot of warning message)
3. install nodejs and our postgres-client packages and any other packages we need.
4. create a directory for the application in `/app`
5. copy our `Gemfile` and `Gemfile.lock` to the temperory directory and install our gems with `bundle install`
6. copy all application files
7. open the application port, by default it's 3000 if you changed it you should change this line
8. set command that will be executed when the container get up to the rails server command

```bash
FROM ruby:2.3.0-slim
ENV LANG=C.UTF-8
RUN apt-get update && apt-get install -qq -y build-essential nodejs libopencv-dev libpq-dev postgresql-client-9.5 imagemagick --fix-missing --no-install-recommends

ENV app /app
RUN mkdir -p $app
ENV INSTALL_PATH $app
ENV RAILS_ENV production
EXPOSE 3000
CMD foreman start

COPY Gemfile* /tmp/
WORKDIR /tmp
RUN bundle install --without="development test" -j4

WORKDIR $app
ADD . $app
RUN mkdir -p tmp/pids
```

**Note:** we copied `Gemfile` first before the application because docker is versioning each step, so if you didn't modify your `Gemfile` it won't re-install the gems and will use the cached version instead, that speed building the image, if you just copied the application each time, docker will see that there is a change in the step so it'll install the gems form scratch each time, and as the image is always a clean machine it will download and install the gems, and for native extensions it will recompile it, and we all know how `nokojiri` is a pain (and basically any other native extension gem).

## Specifying your services in `docker-compose.yml`

`docker-compose` is a tool provided by docker team to define images that works as a network, start and stop it together, and it works as a unit, as docker best practice is to run one process per container, and our application needs more than one process (rails application, postgres process), we'll need another container to hold our database process and link it to our application container.

Our `docker-compose.yml` file could be in the following format:

```yaml
version: '2'
services:
  db:
    image: "postgres:9.5.2"
    restart: always
    env_file:
      - .env
    expose:
      - '5432'
    volumes:
      - /root/data/news/db:/var/lib/postgresql/data

  web:
    build: .
    depends_on:
      - db
    links:
      - db
    volumes:
      - /root/data/news/uploads:/app/public/system
      - /tmp/news/assets:/app/public/assets
    restart: always
    ports:
      - '127.0.0.1:3000:3000'
    env_file:
      - .env
```

In the previous file we defined 2 services each of them assigned a proper name:
* web: for our main application service, it will  build the `Dockerfile` in the current directory `.`, it needs the other container to be up first as specified in `depends_on`, and links to the `db` container in the same network, also I linked 2 directories for a local directories, the uploads directory and the assets directory, so when you destroy an image and build a new one these are the olny directories that will be kept, also i set the `restart: always` to restart the machine whenever docker is restarted, and opened port 3000 to local machine only so that it will be accessible from an HTTP srever (nginx or so), if you wish to map the port to 80 and make it accessible from outside the machine you can replace it with `80:3000` and removing `127.0.0.1` will make it public, also we'll load an environment file `.env` which will be defined later.
* db: a database container depends in `postgres` official image, it will open port `5432` to the other services inside thsi docker-compose network only ( this means you can make another docker-compose file with this port open and it won't conflict) and also it means that the database is not accessible form the host machine and could be accessed only from the `web` container, also mapped the data directory to local directory on host.

## Define your environment file `.env`

we're having all of our secrets in one environement file for both containers as follows:

```bash
RAILS_ENV=production
SECRET_KEY_BASE=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
DATABASE_NAME=production
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
DATABASE_HOST=db
```

1. RAILS_ENV: is the application environement, that is obvious.
2. SECRET_KEY_BASE : a key used by rails to encrypt the session and othe stuff, please make sure that your `secrets.yml` file read it from `ENV[:SECRET_KEY_BASE]` for production.
3. DATABASE_NAME : the application database name, make sure you read it fron `ENV` in your `database.yml` for production section.
4. POSTGRES_USER : a variable needed by postgres image to define the user in image, also please use the same env variable in your `database.yml` production section.
5. POSTGRES_PASSWORD : as postgres user.
6. DATABASE_HOST : the database service name (it is defined as a dns record also for the docker-compose network), also please use it in your `database.yml`.

so our `database.yml` file should read Env variables in production like the following

```yaml
production:
  adapter: postgresql
  encoding: unicode
  pool: 5
  timeout: 5000
  host: <%= ENV['DATABASE_HOST'] %>
  database: <%= ENV['DATABASE_NAME'] %>
  username: <%= ENV['POSTGRES_USER'] %>
  password: <%= ENV['POSTGRES_PASSWORD'] %>
```

it's reading all most of the configuration fron our `ENV`, and these variables are passed from the `.env` by `docker-compose`, and it's only one `.env` file for all docker containers, so it's easier modify/create form your CI like jenkins.


## Testing what you've done

you can test this setup by issuing `docker-compose up` it should pull images and build yours and launch the stack, the only thing is that our database is not created yet, you can do that by isuing `rake db:setup` inside your web container like so `docker-compose run web rake db:setup`. You should be able to access your application from `http://localhost:3000`.

## Capistrano integration

I created a set of tasks that is hooking to the capistrano deployment process and build your images and issue the up/down/restart command, you can use it from [here](https://github.com/blazeeboy/capistrano-decompose), so if you didn't `cap init` please do and now we should have `config/delpoy.rb` and `config/deploy/production.rb`

so you'll need to include `capistrano-decompose` to your gemfile `gem 'capistrano-decompose, require: false'` and `bundle install`, then add it to your `capfile`, `require 'capistrano/decompose'`, this will load the plugin to capistrano decpolyment flow, now you need to configure the plugin, either in the global `deploy.rb` to apply configuration to all environements or add environment specific deployment configuration to `config/deploy/production.rb` as follows:

```ruby
lock '3.5.0'

set :application, 'application_name'
set :repo_url, 'git@applicationhost.com/application_repo_name.git'
set :deploy_to, "/path/to/project/on/server/#{fetch(:application)}"
set :keep_releases, 1
set :decompose_restart, [:web]
set :decompose_web_service, :web
set :decompose_rake_tasks, ['db:migrate', 'db:seed', 'assets:precompile']
```

in `decompose_rake_tasks` i always seed the database, and in my `seed.rb` I make sure that the seeded data is not inserted if it's already there, this is easier for me to modify and it'll be executed each deployment, before that if i needed to insert data to the database after the initial seed, I had to create a migration for it, now i reserve migration for structural changes and seed to insert new data as i need.

now if you tried to `cap production deploy` you are good to go, your application will be deployed toa the server (make sure you install docker on your server of course), and it will be up on port 3000 as we specified, you can either change port to 80 in docker-compose.yml or add a http server like nginx to redirect traffic to this port for certain host.
