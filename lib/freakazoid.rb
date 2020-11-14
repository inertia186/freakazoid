require 'ruby-cleverbot-api'
require 'awesome_print'
require 'yaml'
# require 'pry'

Bundler.require

module Freakazoid
  require 'freakazoid/version'
  require 'freakazoid/chain'
  
  PWD = Dir.pwd.freeze
  
  include Chain
  
  extend self
  
  def run
    loop do
      begin
        stream = Radiator::Stream.new(chain_options)
        
        print "Freakazoid #{Freakazoid::VERSION} initialized.  Watching for replies and mentions for #{account_name} ..."
        
        if meeseeker_options
          require 'redis'
          
          puts ' (streaming with meeseeker) ...'
          
          ctx = Redis.new(url: meeseeker_options[:url])
          
          Redis.new(url: meeseeker_options[:url]).subscribe('hive:op:comment') do |on|
            on.message do |_, message|
              payload = JSON[message]
              comment = Hashie::Mash.new(JSON[ctx.get(payload["key"])]).value rescue nil
              
              process_comment(comment) if !!comment
            end
          end
        else
          puts ' (streaming directly) ...'
          
          stream.operations(:comment) do |comment|
            process_comment(comment)
          end
        end
      rescue => e
        warn e.inspect
        puts e.backtrace.join("\n")
        reset_api
        sleep backoff
      end
    end
  end
  
  def process_comment(comment)
    return if comment.author == account_name # no self-reply
    return if ignored?(comment.author)
    
    metadata = JSON.parse(comment.json_metadata) rescue {}
    app_name = extract_app_name(metadata)
    
    return if except_apps.any? && except_apps.include?(app_name)
    return if only_apps.any? && !only_apps.include?(app_name)
    
    if comment.parent_author == account_name
      puts "Reply to #{account_name} by #{comment.author}"
    else
      # Not a reply, check if there's a mention instead.
      users = extract_users(metadata)
      if users.include? account_name
        puts "Mention of #{account_name} by #{comment.author} (in json_metadata)"
      elsif comment.body =~ /@#{account_name}/
        puts "Mention of #{account_name} by #{comment.author} (in body)"
      else
        return
      end
    end
    
    reply(find_comment(comment.author, comment.permlink))
  end
end
