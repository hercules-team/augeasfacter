require 'pathname'
dir = Pathname.new(__FILE__).parent
$LOAD_PATH.unshift(dir, File.join(dir, 'lib'), File.join(dir, '..', 'lib'))

require 'rubygems'

require 'simplecov'
SimpleCov.start do
  add_filter "/spec/"
end

RSpec.configure do |config|
  config.mock_with :mocha
end

