# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sandman/version'

Gem::Specification.new do |spec|
  spec.name          = "sandman"
  spec.version       = Sandman::VERSION
  spec.authors       = ["pyro2927"]
  spec.email         = ["joseph@pintozzi.com"]
  spec.description   = "Sandman is a gem aimed at helping you manage your SSH keys between GitHub and Bitbucket"
  spec.summary       = "Sandman is a gem aimed at helping you manage your SSH keys between GitHub and Bitbucket"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "github", "~> 0.7.2"
  spec.add_runtime_dependency "bitbucket", "~> 0.0.1"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
