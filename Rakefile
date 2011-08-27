require 'rubygems'
#require 'bundler/setup'

require 'data_mapper'

require 'lib/models'

if ENV['RACK_ENV'] == 'production'
  DataMapper.setup(:default, ENV['DATABASE_URL'])
else
  DataMapper::Logger.new($stdout, :debug)
  DataMapper.setup(:default, {:adapter => 'sqlite3', :database => 'db/development.db'})
end

namespace :db do
  task :migrate do
    DataMapper.auto_migrate!
  end
  task :update do
    DataMapper.auto_upgrade!
  end
end

