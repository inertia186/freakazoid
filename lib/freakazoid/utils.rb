require 'rdiscount'

module Freakazoid
  require 'freakazoid/config'
  
  module Utils
    include Config
    
    def semaphore
       @semaphore ||= Mutex.new
    end
        
    def reset_clever
      @clever = nil
    end
    
    def clever
      @clever ||= Cleverbot.new(cleverbot_api_key)
    end
    
    def merge(options = {})
      comment_md = 'support/reply.md'
      comment_body = if File.exist?(comment_md)
        File.read(comment_md)
      end

      raise "Cannot read #{template} template or template is empty." if comment_body.nil?

      merged = comment_body
      
      options.each do |k, v|
        merged = case k
        when :from
          merged.gsub("${#{k}}", [v].flatten.join(', @'))
        else; merged.gsub("${#{k}}", v.to_s)
        end
      end

      case options[:markup]
      when :html then RDiscount.new(merged).to_html
      when :markdown then merged
      end
    end
    
    def extract_app_name(metadata)
      app = metadata['app'] rescue nil
      app_name = app.split('/').first rescue nil
      
      app_name || 'unknown'
    end
    
    def extract_users(metadata)
      users = metadata['users'] rescue nil
      
      users || []
    end
    
    def parse_slug(slug)
      slug = slug.downcase.split('@').last
      author_name = slug.split('/')[0]
      permlink = slug.split('/')[1..-1].join('/')
      permlink = permlink.split('?')[0]
        
      [author_name, permlink]
    end
  end
end
