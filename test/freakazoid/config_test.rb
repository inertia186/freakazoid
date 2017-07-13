require 'test_helper'

module Freakazoid
  class ConfigTest < Freakazoid::Test
    include Config
    
    def setup
      override_config(
        drotto: {
          block_mode: 'irreversible',
          account_name: 'social',
          posting_wif: '5JrvPrQeBBvCRdjv29iDvkwn3EQYZ9jqfAHzrCyUvfbEbRkrYFC',
          cleverbot_api_key: 'ZmFrZSBjbGV2ZXJib3QgYXBpIGtleQ'
        }, chain_options: {
          chain: 'steem',
          url: 'https://steemd.steemit.com'
        }
      )
    end
  end
end
