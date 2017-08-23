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
          follow_back: true,
          vote_weight: '1.00 %',
          self_vote_weight: '2.00 %'
        }, chain_options: {
          chain: 'steem',
          url: 'https://steemd.steemit.com'
        }
      )
    end
    
    def test_posting_wif
      assert posting_wif
    end
    
    def test_except_apps
      assert except_apps
    end
    
    def test_only_apps
      assert only_apps
    end
    
    def test_follow_back
      assert follow_back?
    end
    
    def test_vote_weight
      assert_equal 100, vote_weight
    end
    
    def test_self_vote_weight
      assert_equal 200, self_vote_weight
    end
  end
end
