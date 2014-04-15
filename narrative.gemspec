# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'narrative/version'

Gem::Specification.new do |spec|
  spec.name          = 'narrative'
  spec.version       = Narrative::VERSION
  spec.authors       = ['Takuya Watanabe', 'Hiroshi Kajisha']
  spec.email         = ['tkywtnb@gmail.com', 'kajisha@gmail.com']
  spec.summary       = %q{atdkk.}
  spec.description   = %q{.}
  spec.homepage      = 'https://github.com/esminc/narrative'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.0.0.beta2'
end
