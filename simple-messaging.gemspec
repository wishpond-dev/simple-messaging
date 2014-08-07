# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simple_messaging/version'

Gem::Specification.new do |spec|
  spec.name          = "simple_messaging"
  spec.version       = SimpleMessaging::VERSION
  spec.authors       = ["Maxime Santerre"]
  spec.email         = ["mooxeh@gmail.com"]
  spec.summary       = %q{Abstraction layer for simple messaging operations}
  spec.description   = """Lets you easily change messaging adapters for simple queue and poll operations"""
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "amqp"
  spec.add_dependency "aws-sdk"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
