require 'test_helper'

module Freakazoid
  class ConfigTest < Freakazoid::Test
    include Config
    
    def setup
      app_key :freakazoid
      agent_id AGENT_ID
      override_config(
        freakazoid: {
          block_mode: 'irreversible',
          account_name: 'social',
          posting_wif: '5JrvPrQeBBvCRdjv29iDvkwn3EQYZ9jqfAHzrCyUvfbEbRkrYFC',
          cleverbot_api_key: 'ZmFrZSBjbGV2ZXJib3QgYXBpIGtleQ',
          vote_weight: '1.00 %',
          self_vote_weight: '2.00 %'
        }, chain_options: {
          chain: 'steem',
          url: 'https://steemd.steemit.com'
        }
      )
    end
    
    def test_vote_weight
      assert_equal 100, vote_weight
    end
    
    def self_test_vote_weight
      assert_equal 200, self_vote_weight
    end
  end
end
