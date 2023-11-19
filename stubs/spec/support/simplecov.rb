# frozen_string_literal: true

require 'simplecov'

SimpleCov.start 'rails' do
  # add_filter 'app/admin' # Exclude files in the admin directory from coverage
  # add_group 'Services', 'app/services' # Group services together in the coverage report
end
