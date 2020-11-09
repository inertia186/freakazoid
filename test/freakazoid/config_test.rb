require 'test_helper'

module Freakazoid
  class ConfigTest < Freakazoid::Test
    include Config
    
    def setup
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
    
    def test_unique_author
      assert_equal 1440, unique_author
    end
  end
end
