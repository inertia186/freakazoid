require 'krang'
require 'ruby-cleverbot-api'
require 'awesome_print'
require 'yaml'
# require 'pry'

Bundler.require

module Freakazoid
  require 'freakazoid/version'
  require 'freakazoid/chain'
  
  include Chain
  
  extend self
  
  app_key :freakazoid
  agent_id AGENT_ID
  
  def run
    loop do
      begin
        stream = Radiator::Stream.new(chain_options)
        
        stream.operations(:comment) do |comment|
          next if comment.author == account_name # no self-reply
          next if ignored?(comment.author)
          
          metadata = JSON.parse(comment.json_metadata) rescue {}
          app_name = extract_app_name(metadata)
          
          next if except_apps.any? && except_apps.include?(app_name)
          next if only_apps.any? && !only_apps.include?(app_name)
          
          if comment.parent_author == account_name
            krang_debug "Reply to #{account_name} by #{comment.author}"
          else
            # Not a reply, check if there's a mention instead.
            users = extract_users(metadata)
            next unless users.include? account_name
            krang_debug "Mention of #{account_name} by #{comment.author}"
          end
          
          reply(find_comment(comment.author, comment.permlink))
        end
      rescue => e
        krang_warning e.inspect, e
        reset_api
        sleep backoff
      end
    end
  end
end
