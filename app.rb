require 'rubygems'
#require 'bundler/setup'

require 'data_mapper'
require 'haml'
require 'json'
require 'sinatra'
require 'rack-flash'

require 'lib/models'

configure do
  if ENV['RACK_ENV'] == 'production'
    DataMapper.setup(:default, ENV['DATABASE_URL'])
  else
    DataMapper::Logger.new($stdout, :debug)
    DataMapper.setup(:default, {:adapter => 'sqlite3', :database => 'db/development.db'})
  end

  set :sessions, true
  use Rack::Flash

  #mime_type :json, 'application/json'
end

helpers do
  
end

error 401 do
  '401 Unauthorized'
end

get '/' do
  haml :index
end

get '/hoge/new' do
  haml :"hoge/new"
end

post '/hoge/create' do
  p params

  hoge = Hoge.new(
    :name => params[:name]
  )

  if hoge.valid?
    hoge.save
    id = hoge.id

    redirect '/hoge/' + id.to_s
  else
    flash[:error] = params[:name] + ' is already taken'
    redirect '/hoge/new'
  end

end

get '/hoge/:id/edit' do
  @hoge = Hoge.first(:id => params[:id])

  haml :"hoge/edit"
end

post '/hoge/:id/update' do
  hoge = Hoge.first(:id => params[:id])
  hoge.description = params[:description]
  
  id = hoge.id
  if hoge.valid?
    hoge.save

    flash[:notice] = 'update succeeded'
    redirect '/hoge/' + id.to_s
  else
    flash[:error] = 'update failed'
    redirect '/hoge/' + id.to_s + '/edit'
  end
end

get '/hoge/:id' do
  @hoge = Hoge.first(:id => params[:id].to_i)
  p @hoge

  haml :"hoge/show"
end

get '/participant/' do
  @participants = Participant.all

  haml :participant
end

get '/game/new' do
  haml :"game/new"
end

post '/game/create' do
end

get '/game/:id' do
end

# APIs
#
get '/api/login' do

end

get '/api/game/:id' do
  game = Game.first(:id => params[:id])
  if game
    res = {:title => game.title}
    participants = []
    game.participants.each do |p|
      participant = {}
      participant[:id] = p.id
      participant[:name] = p.name
      participant[:latitude] = p.latitude
      participant[:longitude] = p.longitude
      participants << participant
    end
    res[:participants] = participants

    JSON.generate(res)
  else
    status 401
    JSON.generate({})
  end 
end



#
# example
#   http://hogehost/api/position   
#
get '/api/position/all' do
end

#
# example
#   http://hogehost/api/position/update?username=miminashi&lat=35.36374219970138&long=136.6078770160675
#
post '/api/position/update' do
  p params
end

