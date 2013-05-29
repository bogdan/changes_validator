$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$:.unshift(File.dirname(__FILE__))
require 'rubygems'
require 'bundler/setup'
require 'transition_validator' # and any other gems you need

RSpec.configure do |config|
  # some (optional) config here
end
