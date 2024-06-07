# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'changes_validator/version'

Gem::Specification.new do |spec|
  spec.name          = "changes_validator"
  spec.version       = ChangesValidator::VERSION
  spec.authors       = ["Bogdan Gusiev"]
  spec.email         = ["agresso@gmail.com"]
  spec.description   = %q{ActiveModel validator that acts like state machine}
  spec.summary       = %q{This validator allows to specify a mapping of allowed changess for given attribute and validate that this attribute can only be transfered according to changess map}
  spec.homepage      = "https://github.com/bogdan/changes_validator"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "activemodel", ">= 5.0.0"
  spec.add_development_dependency "byebug" if RUBY_VERSION >= "2.0"
end
