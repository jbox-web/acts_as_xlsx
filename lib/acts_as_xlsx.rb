# frozen_string_literal: true

require 'axlsx'

require 'zeitwerk'
loader = Zeitwerk::Loader.for_gem
loader.setup

module ActsAsXlsx
  require 'acts_as_xlsx/engine' if defined?(Rails)
end
