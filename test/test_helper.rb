$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

if ENV["HELL_ENABLED"] || ENV['CODECLIMATE_REPO_TOKEN']
  require 'simplecov'
  if ENV['CODECLIMATE_REPO_TOKEN']
    require "codeclimate-test-reporter"
    SimpleCov.start CodeClimate::TestReporter.configuration.profile
    CodeClimate::TestReporter.start
  else
    SimpleCov.start
  end
  SimpleCov.merge_timeout 3600
end

require 'freakazoid'

require 'minitest/autorun'

# require 'webmock/minitest'
require 'vcr'
require 'yaml'
require 'pry'
require 'securerandom'
require 'delorean'

if !!ENV['VCR']
  VCR.configure do |c|
    c.cassette_library_dir = 'test/fixtures/vcr_cassettes'
    c.hook_into :webmock
  end
end

if ENV["HELL_ENABLED"]
  require "minitest/hell"
  
  class Minitest::Test
    # See: https://gist.github.com/chrisroos/b5da6c6a37ac8af5fe78
    parallelize_me! unless defined? WebMock
  end
else
  require "minitest/pride"
end

if defined? WebMock 
  WebMock.disable_net_connect!(allow_localhost: false, allow: 'codeclimate.com:443')
end

module Freakazoid
  module Config
    def yml
      {
        freakazoid: {
          block_mode: 'irreversible',
          account_name: 'social',
          posting_wif: '5JrvPrQeBBvCRdjv29iDvkwn3EQYZ9jqfAHzrCyUvfbEbRkrYFC',
          cleverbot_api_key: 'ZmFrZSBjbGV2ZXJib3QgYXBpIGtleQ',
          follow_back: true,
          unique_author: 1440,
          vote_weight: '1.00 %',
          self_vote_weight: '2.00 %'
        }, chain_options: {
          chain: 'hive',
          url: 'https://api.hive.blog'
        }
      }
    end
  end
end

class Freakazoid::Test < MiniTest::Test
  def save filename, result
    f = File.open("#{File.dirname(__FILE__)}/support/#{filename}", 'w+')
    f.write(result)
    f.close
  end
end
