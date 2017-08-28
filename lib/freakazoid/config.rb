module Freakazoid
  module Config
    include Krang::Config
    
    def account_name
      default_value(:account_name) || config[app_key][:account_name]
    end
    
    def posting_wif
      default_value(:posting_wif) || config[app_key][:posting_wif]
    end
    
    def cleverbot_api_key
      default_value(:cleverbot_api_key) || config[app_key][:cleverbot_api_key]
    end
    
    def except_apps
      (default_value(:except_apps) || config[app_key][:except_apps]).to_s.split(' ')
    end
    
    def only_apps
      (default_value(:only_apps) || config[app_key][:only_apps]).to_s.split(' ')
    end
    
    def follow_back?
      (default_value(:follow_back) || config[app_key][:follow_back]).to_s == 'true'
    end
    
    def unique_author
      (default_value(:unique_author) || config[app_key][:unique_author] || '0').to_i
    end
    
    def vote_weight
      ((default_value(:vote_weight) || config[app_key][:vote_weight] || '0.00 %').to_f * 100.0).to_i
    end
    
    def self_vote_weight
      ((default_value(:self_vote_weight) || config[app_key][:self_vote_weight] || '0.00 %').to_f * 100.0).to_i
    end
  end
end
