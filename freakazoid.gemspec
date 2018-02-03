# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'freakazoid/version'

Gem::Specification.new do |spec|
  spec.name = 'freakazoid'
  spec.version = Freakazoid::VERSION
  spec.authors = ['Anthony Martin']
  spec.email = ['freakazoid@martin-studio.com']

  spec.summary = %q{Cleverbot integration for STEEM.}
  spec.description = %q{That is (hopefully) very clever.}
  spec.homepage = 'https://github.com/inertia186/freakazoid'
  spec.license = 'CC0 1.0'

  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test)/}) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.15', '>= 1.15.4'
  spec.add_development_dependency 'rake', '~> 12.1', '>= 12.1.0'
  spec.add_development_dependency 'minitest', '~> 5.9', '>= 5.9.0'
  spec.add_development_dependency 'minitest-line', '~> 0.6.3'
  spec.add_development_dependency 'minitest-proveit'
  spec.add_development_dependency 'webmock', '~> 3.1', '>= 3.1.0'
  spec.add_development_dependency 'vcr', '~> 3.0', '>= 3.0.3'
  spec.add_development_dependency 'simplecov', '~> 0.15.1'
  spec.add_development_dependency 'yard', '~> 0.9.9'
  spec.add_development_dependency 'pry', '~> 0.11.1'
  spec.add_development_dependency 'awesome_print', '~> 1.7', '>= 1.7.0'
  spec.add_development_dependency 'delorean', '~> 2.1', '>= 2.1.0'

  spec.add_dependency 'krang'
  spec.add_dependency 'rest-client', '~> 2.0', '>= 2.0.2' # required by ruby-cleverbot-api
  spec.add_dependency 'ruby-cleverbot-api', '~> 1.0', '>= 1.0.6'
  spec.add_dependency 'rdiscount', '~> 2.2', '>= 2.2.0.1'
end
