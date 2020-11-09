require 'test_helper'

module Freakazoid
  class FreakazoidTest < Freakazoid::Test
    include Config
    
    def setup
    end
    
    def test_backoff
      assert Freakazoid.backoff
    end
  end
end
