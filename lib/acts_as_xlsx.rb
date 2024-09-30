# frozen_string_literal: true

# require external dependencies
require 'axlsx'
require 'zeitwerk'

# load zeitwerk
Zeitwerk::Loader.for_gem.tap do |loader| # rubocop:disable Style/SymbolProc
  loader.setup
end

module ActsAsXlsx
  require_relative 'acts_as_xlsx/engine' if defined?(Rails)
end
