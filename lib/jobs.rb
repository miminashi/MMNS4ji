#coding:utf-8

=begin
require 'rubygems'
require 'bundler/setup'

require 'redis'
require 'dm-core'
require 'twitter'

require 'lib/constants'
require 'lib/models'
=end

require 'resque'
require 'twitter'

require 'lib/constants'

class TweetJob
  @queue = :haruyabirthday

  def self.perform(access_token, access_token_secret)
    Twitter.configure do |config|
      config.consumer_key = CONSUMER_KEY
      config.consumer_secret = CONSUMER_SECRET
      config.oauth_token = access_token
      config.oauth_token_secret = access_token_secret
    end
    
    client = Twitter::Client.new
    begin
      #client.update('ハルヤ誕生日かよ・・・')
      client.update('ハルヤ個展かよ・・・')
      p 'tweet succeeded'
    rescue
      p 'tweet failed'
    end
  end
end
