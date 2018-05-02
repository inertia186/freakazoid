require 'test_helper'

module Freakazoid
  class ChainTest < Freakazoid::Test
    include Chain
    
    def setup
      app_key :freakazoid
      agent_id AGENT_ID
      override_config(
        freakazoid: {
          block_mode: 'irreversible',
          account_name: 'social',
          posting_wif: '5JrvPrQeBBvCRdjv29iDvkwn3EQYZ9jqfAHzrCyUvfbEbRkrYFC',
          cleverbot_api_key: 'ZmFrZSBjbGV2ZXJib3QgYXBpIGtleQ',
          unique_author: 1440
        }, chain_options: {
          chain: 'steem',
          url: 'https://api.steemit.com'
        }
      )
    end
    
    def test_reset_api
      assert_nil reset_api
    end
    
    def test_reset_follow_api
      assert_nil reset_follow_api
    end
    
    def test_follow_api
      assert follow_api
    end
    
    def test_voted
      assert voted?(find_comment('twitterpated', 'hyaluronic-acid-the-ingredient-you-need-for-youthful-skin'))
    end
    
    def test_not_voted
      refute voted?(find_comment('banjo', 'banjo-report-for-thursday-august-24-2017'))
    end
    
    def test_backoff
      assert backoff
    end
    
    def test_reset_properties
      assert_nil reset_properties
    end
    
    def test_properties
      assert properties
    end
    
    def test_properties_timeout
      assert properties
      
      Delorean.jump 31 do
        assert properties
      end
    end
    
    def test_comment
      refute_nil find_comment('inertia', 'macintosh-napintosh')
    end
    
    def test_comment_bogus
      assert_nil find_comment('bogus', 'bogus')
    end
    
    def test_followed_by
      assert followed_by?('papa-pepper')
    end
    
    def test_following
      refute following?('papa-pepper')
    end
    
    def test_reply
      result = reply(find_comment('inertia', 'macintosh-napintosh'))
    end
    
    def test_reply_comment
      result = reply(find_comment('admin', 'firstpost'))
    end
    
    def test_already_voted_for
      refute already_voted_for?('inertia')
    end
  end
end
