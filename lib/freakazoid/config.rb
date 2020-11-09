module Freakazoid
  module Config
    def account_name
      default_value(:account_name) || yml[:freakazoid][:account_name]
    end
    
    def posting_wif
      default_value(:posting_wif) || yml[:freakazoid][:posting_wif]
    end
    
    def cleverbot_api_key
      default_value(:cleverbot_api_key) || yml[:freakazoid][:cleverbot_api_key]
    end
    
    def except_apps
      (default_value(:except_apps) || yml[:freakazoid][:except_apps]).to_s.split(' ')
    end
    
    def only_apps
      (default_value(:only_apps) || yml[:freakazoid][:only_apps]).to_s.split(' ')
    end
    
    def follow_back?
      (default_value(:follow_back) || yml[:freakazoid][:follow_back]).to_s == 'true'
    end
    
    def unique_author
      (default_value(:unique_author) || yml[:freakazoid][:unique_author] || '0').to_i
    end
    
    def vote_weight
      ((default_value(:vote_weight) || yml[:freakazoid][:vote_weight] || '0.00 %').to_f * 100.0).to_i
    end
    
    def self_vote_weight
      ((default_value(:self_vote_weight) || yml[:freakazoid][:self_vote_weight] || '0.00 %').to_f * 100.0).to_i
    end
    
    def mirror_mute_account_names
      (default_value(:mirror_mute_account_names) || yml[:freakazoid][:mirror_mute_account_names]).to_s.split(' ') + [account_name]
    end
    
    def meeseeker_options
      yml[:meeseeker_options]
    end
    
    def chain_options
      yml[:chain_options]
    end
  private
    def default_value(key)
      ENV[key.to_s.upcase]
    end
    
    def chain
      @chain_hash ||= yml[:chain]
    end
    
    def yml
      return @yml if !!@yml
      
      config_yaml_path = "#{Freakazoid::PWD}/config.yml"
      
      @yml = if File.exist?(config_yaml_path)
        YAML.load_file(config_yaml_path)
      else
        raise "Create a file: #{config_yaml_path}"
      end
      
      @yml
    end
  end
end
