module Freakazoid
  module Config
    DEFAULT_LOGGER = Logger.new('freakazoid.log')
    
    DEFAULT_CHAIN_OPTIONS = {
      logger: DEFAULT_LOGGER
    }
    
    @@override_config = nil
    
    def override_config(override_config)
      @@override_config = override_config
    end
    
    def config
      return @@override_config if !!@@override_config
      
      config_yml = 'config.yml'
      config = if File.exist?(config_yml)
        YAML.load_file(config_yml)
      else
        raise "Create a file: #{config_yml}"
      end
    end
    
    def block_mode
      ENV['FREAKAZOID_BLOCK_MODE'] || config[:freakazoid][:block_mode]
    end
    
    def account_name
      ENV['FREAKAZOID_ACCOUNT_NAME'] || config[:freakazoid][:account_name]
    end
    
    def posting_wif
      ENV['FREAKAZOID_POSTING_DIF'] || config[:freakazoid][:posting_wif]
    end
    
    def cleverbot_api_key
      ENV['FREAKAZOID_CLEVERBOT_API_KEY'] || config[:freakazoid][:cleverbot_api_key]
    end
    
    def chain_options
      chain_options = config[:chain_options].merge(DEFAULT_CHAIN_OPTIONS)
      
      chain = ENV['FREAKAZOID_CHAIN_OPTIONS_CHAIN']
      chain_options = chain_options.merge(chain: chain.to_s) if !!chain
      url = ENV['FREAKAZOID_CHAIN_OPTIONS_URL']
      chain_options = chain_options.merge(url: url) if !!url
      
      chain_options.dup
    end
    
    def logger
      DEFAULT_LOGGER
    end
  end
end
