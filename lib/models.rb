#coding:utf-8

=begin
class Hoge
  include DataMapper::Resource

  property :id, Serial
  property :title, String, :length => 255, :required => true
  property :description, Text
  property :created, Date

  #has n, :participants
end
=end

class User
  include DataMapper::Resource

  property :id, Serial
  property :twitter_id, Integer, :required => true
  property :twitter_screen_name, String, :length => 32, :required => true
  property :created, Date
  property :access_token, String, :length => 255
  property :access_token_secret, String, :length => 255

  #has n, :participants
end

