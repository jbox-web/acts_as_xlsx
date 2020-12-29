RSpec.configure do |config|
  # Use DB agnostic schema by default
  load Rails.root.join('db', 'schema.rb').to_s

  config.order = :random
  Kernel.srand config.seed

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  if ENV.key?('GITHUB_ACTIONS')
    config.around(:each) do |ex|
      ex.run_with_retry retry: 3
    end
  end
end
