require 'dm-core'
require 'haml'
require 'sinatra/base'
require 'rack-flash'
require 'oauth'
require 'twitter'

require 'lib/models'
require 'lib/constants'

class MMNS4ji < Sinatra::Base
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
    set :haml, :format => :html5
    set :public, File.dirname(__FILE__) + '/public'
  end

  helpers do
    def oauth_consumer
      consumer = OAuth::Consumer.new(CONSUMER_KEY, CONSUMER_SECRET, {
        :site => 'https://api.twitter.com'
      })
      return consumer
    end
  end

  error 401 do
    '401 Unauthorized'
  end
  
  get '/' do
    haml :index
  end
  
  get '/user/new' do
    consumer = oauth_consumer
    request_token = consumer.get_request_token(:oauth_callback => 'http://hentaijks.or6.jp/oauth/callback')
    session[:request_token] = request_token.token
    session[:request_token_secret] = request_token.secret
  
    redirect request_token.authorize_url
  end
  
  get '/oauth/callback' do
    p params
    request_token = OAuth::RequestToken.new(
      oauth_consumer,
      session[:request_token],
      session[:request_token_secret]
    )
    begin
      access_token = request_token.get_access_token(
        {},
        :oauth_token => params[:oauth_token],
        :oauth_verifier => params[:oauth_verifier]
      )
      flash[:notice] = 'Twitterとの連携に成功しました'
    rescue OAuth::Unauthorized => e
      flash[:error] = 'Twitterとの連携に失敗しました'
      redirect '/'
    end
  
    Twitter.configure do |config|
      config.consumer_key = CONSUMER_KEY
      config.consumer_secret = CONSUMER_SECRET
      config.oauth_token = access_token.token
      config.oauth_token_secret = access_token.secret
    end
  
    #p Twitter.verify_credentials
    p Twitter.verify_credentials.screen_name
    p Twitter.verify_credentials.id
  
    verify_credentials = Twitter.verify_credentials
  
    User.first_or_create(
      :twitter_id => verify_credentials.id,
      :twitter_screen_name => verify_credentials.screen_name,
      :access_token => access_token.token,
      :access_token_secret => access_token.secret
    )
  
    redirect '/'
  end
end

