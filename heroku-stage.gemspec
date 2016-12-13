# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "heroku/stage/version"

Gem::Specification.new do |spec|
  spec.name          = "heroku-stage"
  spec.version       = Heroku::Stage::VERSION
  spec.authors       = ["Platanus", "Juan Ignacio Donoso"]
  spec.email         = ["rubygems@platan.us", "juan.ignacio@platan.us"]
  spec.homepage      = "https://github.com/platanus/heroku-stage"
  spec.summary       = "Read stage name from heroku pipelines"
  spec.description   = "Based on convention this gem will get the heroku pipeline stage from the app name"
  spec.license       = "MIT"

  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rails"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.4"
  spec.add_development_dependency "guard-rspec", "~> 4.7"
  spec.add_development_dependency "pry"
end
