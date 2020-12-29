# frozen_string_literal: true

require_relative 'lib/acts_as_xlsx/version'

Gem::Specification.new do |s|
  s.name        = 'acts_as_xlsx'
  s.version     = ActsAsXlsx::VERSION::STRING
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Nicolas Rodriguez']
  s.email       = ['nicoladmin@free.fr']
  s.homepage    = 'https://github.com/jbox-web/acts_as_xlsx'
  s.summary     = 'A Rails roles solution.'
  s.license     = 'MIT'

  s.required_ruby_version = '>= 2.5.0'

  s.files = `git ls-files`.split("\n")

  s.add_runtime_dependency 'caxlsx'
  s.add_runtime_dependency 'i18n'
  s.add_runtime_dependency 'rails', '>= 5.1'
  s.add_runtime_dependency 'zeitwerk'

  s.add_development_dependency 'appraisal'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rspec-retry'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'simplecov', '~> 0.17.1'
  s.add_development_dependency 'sqlite3', '~> 1.4.0'
end
