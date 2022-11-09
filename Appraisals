# frozen_string_literal: true

RAILS_VERSIONS = %w[
  6.0.4
  6.1.5
  7.0.2
].freeze

RAILS_VERSIONS.each do |version|
  appraise "rails_#{version}" do
    gem 'rails', version
  end
end
