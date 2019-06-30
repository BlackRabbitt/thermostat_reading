# frozen_string_literal: true

require 'simplecov'
SimpleCov.start 'rails' do
  add_filter 'app/mailers'
  add_filter 'app/channels'
end
# This outputs the report to your public folder
SimpleCov.coverage_dir 'public/coverage'
