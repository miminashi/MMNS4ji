class Hoge
  include DataMapper::Resource

  property :id, Serial
  property :title, String, :length => 255, :required => true
  property :description, Text
  property :created, Date

  #has n, :participants
end

