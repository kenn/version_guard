# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'version_guard/version'

Gem::Specification.new do |spec|
  spec.name          = 'version_guard'
  spec.version       = VersionGuard::VERSION
  spec.authors       = ['Kenn Ejima']
  spec.email         = ['kenn.ejima@gmail.com']
  spec.description   = %q{A gem-style version checker}
  spec.summary       = %q{A gem-style version checker}
  spec.homepage      = 'https://github.com/kenn/version_guard'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
end
