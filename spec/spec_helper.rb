# frozen_string_literal: true

require 'simplecov'
require 'simplecov_json_formatter'

# Start SimpleCov
SimpleCov.start do
  formatter SimpleCov::Formatter::JSONFormatter
  add_filter 'spec/'
end

# Load Rails dummy app
ENV['RAILS_ENV'] = 'test'
require File.expand_path('dummy/config/environment.rb', __dir__)

# Load test gems
require 'rspec/rails'

# Load our own config
require_relative 'config_rspec'

posts = []
posts << Post.create!(name: 'first post',  title: 'This is the first post',  content: 'I am a very good first post!', votes: 1)
posts << Post.create!(name: 'second post', title: 'This is the second post', content: 'I am the best post!',          votes: 7)

authors = []
authors << Author.create!(name: 'bob')
authors << Author.create!(name: 'joe')

comments = []
comments << Comment.create!(content: 'wow, that was a nice post!',       post: posts[0], author: authors[1])
comments << Comment.create!(content: 'Are you really the best post?',    post: posts[1], author: authors[0])
comments << Comment.create!(content: 'Only until someone posts better!', post: posts[1], author: authors[0])
