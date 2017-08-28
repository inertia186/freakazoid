module Freakazoid
  require 'freakazoid/utils'
  
  module Chain
    include Krang::Chain
    include Utils
    
    def reset_follow_api
      @follow_api = nil
    end
    
    def follow_api
      with_follow_api
    end
    
    def with_follow_api(&block)
      loop do
        @follow_api ||= Radiator::FollowApi.new(chain_options)
        
        return @follow_api if block.nil?
        
        begin
          yield @follow_api
          break
        rescue => e
          warning "API exception, retrying (#{e})", e
          reset_follow_api
          sleep backoff
          redo
        end
      end
    end
    
    def followed_by?(account)
      followers = []
      count = -1

      until count == followers.size
        count = followers.size
        response = nil
        with_follow_api do |follow_api|
          response = follow_api.get_followers(account_name, followers.last, 'blog', 1000)
        end
        followers += response.result.map(&:follower)
        followers = followers.uniq
      end

      followers.include? account
    end
    
    def following?(account)
      following = []
      count = -1

      until count == following.size
        count = following.size
        response = nil
        with_follow_api do |follow_api|
          response = @follow_api.get_following(account_name, following.last, 'blog', 100)
        end
        following += response.result.map(&:following)
        following = following.uniq
      end

      following.include? account
    end
    
    def voted_for_authors
      @voted_for_authors ||= {}
      limit = if @voted_for_authors.empty?
        10000
      else
        300
      end
      
      semaphore.synchronize do
        response = nil
        with_api do |api| 
          response = api.get_account_history(account_name, -limit, limit)
        end
        result = response.result
        result.reverse.each do |i, tx|
          op = tx['op']
          next unless op[0] == 'vote'
          
          timestamp = Time.parse(tx['timestamp'] + 'Z')
          latest = @voted_for_authors[op[1]['author']]
          
          if latest.nil? || latest < timestamp
            @voted_for_authors[op[1]['author']] = timestamp
          end
        end
      end
      
      @voted_for_authors
    end

    def already_voted_for?(author)
      return false if unique_author == 0
      
      now = Time.now.utc
      voted_in_threshold = []
      
      voted_for_authors.each do |author, vote_at|
        if now - vote_at < unique_author * 60
          voted_in_threshold << author
        end
      end
      
      return true if voted_in_threshold.include? author
      
      false
    end

    def voted?(comment)
      return false if comment.nil?
      voters = comment.active_votes
      
      if voters.map(&:voter).include? account_name
        debug "Already voted for: #{comment.author}/#{comment.permlink} (id: #{comment.id})"
        true
      else
        false
      end
    end

    def reply(comment)
      clever_response = nil
      metadata = JSON.parse(comment.json_metadata) rescue {}
      tags = metadata['tags'] || []
      
      begin
        quote = if comment.body.size > 140
          s = comment.body
          s = s[rand(s.length), rand(s.length - 1) + 1]
        else
          comment.body
        end + ' ' + tags.join(' ')
        
        clever_response = clever.send_message(quote, comment.author)
      rescue => e
        error e.inspect, backtrace: e.backtrace
        debug 'Resetting cleverbot.'
        reset_clever
      end
      
      if clever_response.nil?
        warn 'Got nil response from cleverbot.'
        return
      end
      
      # We are using asynchronous replies because sometimes the blockchain
      # rejects replies that happen too quickly.
      thread = Thread.new do
        author = comment.author
        permlink = comment.permlink
        parent_permlink = comment.parent_permlink
        parent_author = comment.parent_author
        votes = []
          
        debug "Replying to #{author}/#{permlink}"
      
        loop do
          merge_options = {
            markup: :html,
            content_type: parent_author == '' ? 'post' : 'comment',
            account_name: account_name,
            author: author,
            body: clever_response
          }
          
          reply_metadata = {
            app: Freakazoid::AGENT_ID
          }
          
          reply_metadata[:tags] = [tags.first] if tags.any?
          reply_permlink = "re-#{author.gsub(/[^a-z0-9\-]+/, '-')}-#{permlink.split('-')[0..5][1..-2].join('-')}-#{Time.now.utc.strftime('%Y%m%dt%H%M%S%Lz')}" # e.g.: 20170225t235138025z
          
          reply = {
            type: :comment,
            parent_permlink: permlink,
            author: account_name,
            permlink: reply_permlink,
            title: '',
            body: merge(merge_options),
            json_metadata: reply_metadata.to_json,
            parent_author: author
          }
          
          if vote_weight != 0 && followed_by?(author) && !voted?(comment)
            votes << {
              type: :vote,
              voter: account_name,
              author: author,
              permlink: permlink,
              weight: vote_weight
            }
          end
          
          if self_vote_weight != 0
            votes << {
              type: :vote,
              voter: account_name,
              author: account_name,
              permlink: reply_permlink,
              weight: self_vote_weight
            }
          end
          
          tx = Radiator::Transaction.new(chain_options.merge(wif: posting_wif))
          
          if follow_back?
            if followed_by?(author) && !following?(author)
              tx.operations << {
                type: :custom_json,
                required_auths: [],
                required_posting_auths: [account_name],
                id: 'follow',
                json: [
                  :follow, {
                    follower: account_name,
                    following: author,
                    what: [:blog]
                  }
                ].to_json
              }
            end
          end
          
          tx.operations << reply
          
          if votes.size > 0
            tx.operations << votes[0]
          end
          
          response = nil
          
          begin
            sleep Random.rand(3..20) # stagger procssing
            semaphore.synchronize do
              response = tx.process(true)
            end
          rescue => e
            warning "Unable to reply: #{e}", e
          end
          
          if !!response && !!response.error
            message = response.error.message
            if message.to_s =~ /You may only comment once every 20 seconds./
              warning "Retrying comment: commenting too quickly."
              sleep Random.rand(20..40) # stagger retry
              redo
            elsif message.to_s =~ /STEEMIT_MAX_PERMLINK_LENGTH: permlink is too long/
              error "Failed comment: permlink too long"
              break
            elsif message.to_s =~ /missing required posting authority/
              error "Failed vote: Check posting key."
              break
            elsif message.to_s =~ /unknown key/
              error "Failed vote: unknown key (testing?)"
              break
            elsif message.to_s =~ /tapos_block_summary/
              warning "Retrying vote/comment: tapos_block_summary (?)"
              redo
            elsif message.to_s =~ /now < trx.expiration/
              warning "Retrying vote/comment: now < trx.expiration (?)"
              redo
            elsif message.to_s =~ /signature is not canonical/
              warning "Retrying vote/comment: signature was not canonical (bug in Radiator?)"
              redo
            end
          end
          
          info response unless response.nil?
          
          break
        end
          
        begin
          if votes.size > 1
            sleep 3
            tx = Radiator::Transaction.new(chain_options.merge(wif: posting_wif))
            tx.operations << votes[1]
            tx.process(true)
          end
        rescue => e
          warning "Unable to vote: #{e}", e
        end
      end
    end
  end
end

class Cleverbot
  def send_message(message, conversation_id)
    enc_cs = CGI.escape(@cs)
    enc_message = CGI.escape(message.strip)
    enc_conversation_id = CGI.escape(conversation_id.strip)
    url = "#{@api_url}&input=#{enc_message}&cs=#{enc_cs}"
    url += "&conversation_id=#{enc_conversation_id}"
    response = make_get(url)
    puts ERRORS[response.code] if ERRORS.key?(response.code)
    clever_response = JSON.parse(response)
    @cs = clever_response['cs']
    clever_response['output']
  end
end
