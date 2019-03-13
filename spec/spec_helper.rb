require 'simplecov'

# Start SimpleCov
SimpleCov.start do
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
posts << Post.new(name: 'first post', title: 'This is the first post', content: 'I am a very good first post!', votes: 1)
posts << Post.new(name: 'second post', title: 'This is the second post', content: 'I am the best post!', votes: 7)
posts.each { |p| p.save! }

authors = []
authors << Author.new(name: 'bob')
authors << Author.new(name: 'joe')

comments = []
comments << Comment.new(post: posts[0], content: 'wow, that was a nice post!', author: authors[1])
comments << Comment.new(content: 'Are you really the best post?', post: posts[1], author: authors[0])
comments << Comment.new(content: 'Only until someone posts better!', post: posts[1], author: authors[0])
comments.each { |c| c.save }
