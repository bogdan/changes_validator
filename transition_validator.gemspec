# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'transition_validator/version'

Gem::Specification.new do |spec|
  spec.name          = "transition_validator"
  spec.version       = TransitionValidator::VERSION
  spec.authors       = ["Bogdan Gusiev"]
  spec.email         = ["agresso@gmail.com"]
  spec.description   = %q{ActiveModel validator that acts like state machine}
  spec.summary       = %q{This validator allows to specify a mapping of allowed transitions for given attribute and validate that this attribute can only be transfered according to transitions map}
  spec.homepage      = "https://github.com/bogdan/transition_validator"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "activemodel"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
