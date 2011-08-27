require 'app.rb'
require 'test/unit'
require 'rack/test'

ENV['RACK_ENV'] = 'test'

class AppTest << Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_hoge
  end
end

