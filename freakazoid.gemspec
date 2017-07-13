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

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 12.0.0'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'minitest-line'
  spec.add_development_dependency 'minitest-proveit'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'faraday'
  spec.add_development_dependency 'typhoeus'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'codeclimate-test-reporter', '~> 0.5.2'
  spec.add_development_dependency 'yard'
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'delorean'

  spec.add_dependency 'radiator'
  spec.add_dependency 'ruby-cleverbot-api', '~> 1.0', '>= 1.0.6'
  spec.add_dependency 'awesome_print'
  spec.add_dependency 'rdiscount'
end
