require 'pathname'
dir = Pathname.new(__FILE__).parent

require 'rubygems'

require 'simplecov'
SimpleCov.start do
  add_filter "/modules/"
  add_filter "/spec/"
end

require 'puppetlabs_spec_helper/module_spec_helper'

RSpec.configure do |config|
  config.mock_with :mocha
end

