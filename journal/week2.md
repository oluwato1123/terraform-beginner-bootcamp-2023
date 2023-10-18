# Terraform Beginner Bootcamp 2023 - Week 2

## Working with Ruby

### Bundler

Bundler is a package manager for running ruby. It is the primary way to install ruby packages (known as gems) for ruby.

#### Install Gems 

You need to create a Gemfile and define your gems in that file

```rb
source "https://rubygems.org"

gem 'sinatra'
gem 'rake'
gem 'pry'
gem 'puma'
gem 'activerecord'
```

Then you need to run the `bundle install` command.

This will install the gems on the system globally (unlike nodejs which install packages in place in a folder called node_modules)

#### Executing ruby scripts in the context of bundler

We have to use `bundle exec` to tell future ruby script to use the gems we installed.  

### Sinatra

Sinatra is a micro web-framework for ruby to build web apps

It is great for mock or development servers or for very simple projects

You can create a web-server in a single file.

https://sinatrarb.com/

## Terratowns Mock Server

### Running the web server

We can run the web server by executing the following commands:

```rb
bundle install
bundle exec ruby server.rb
```

All of the code for our server is stored un the `server.rb` file.