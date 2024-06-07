# test/test_helper.rb

require 'minitest/autorun'
require 'minitest/reporters'
require_relative '../lib/changes_validator'

# Use Minitest Reporters for better test output
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

