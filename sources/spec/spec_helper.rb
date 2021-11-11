# frozen_string_literal: true

require File.expand_path("#{File.dirname(__FILE__)}/../lib/store")
require File.expand_path("#{File.dirname(__FILE__)}../../lib/translator")
require File.expand_path("#{File.dirname(__FILE__)}/../lib/alfred_response_collection")

require 'rspec'
require 'ostruct'
require 'vcr'
require 'awesome_print'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!
end

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
end
