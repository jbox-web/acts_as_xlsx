# frozen_string_literal: true

require_relative 'lib/acts_as_xlsx/version'

Gem::Specification.new do |s|
  s.name        = 'acts_as_xlsx'
  s.version     = ActsAsXlsx::VERSION::STRING
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Nicolas Rodriguez']
  s.email       = ['nico@nicoladmin.fr']
  s.homepage    = 'https://github.com/jbox-web/acts_as_xlsx'
  s.summary     = 'A Rails roles solution.'
  s.license     = 'MIT'

  s.required_ruby_version = '>= 3.1.0'

  s.files = `git ls-files`.split("\n")

  s.add_dependency 'caxlsx'
  s.add_dependency 'i18n'
  s.add_dependency 'rails', '>= 7.0'
  s.add_dependency 'zeitwerk'
end
