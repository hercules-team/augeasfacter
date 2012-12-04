source :rubygems

if ENV.key?('PUPPET_VERSION')
  puppetversion = "~> #{ENV['PUPPET_VERSION']}"
else
  puppetversion = ['>= 0.25']
end

if ENV.key?('FACTER_VERSION')
  facterversion = "~> #{ENV['FACTER_VERSION']}"
else
  facterversion = ['= 1.6.13']
end

gem 'librarian-puppet'
gem 'puppet', puppetversion
gem 'ruby-augeas', '>= 0.3.0'
gem 'facter', facterversion

group :development do
  gem 'puppet-lint'
  gem 'puppetlabs_spec_helper', '>= 0.2.0'
  gem 'rake'
  gem 'rspec-puppet'
  gem 'simplecov'
end
