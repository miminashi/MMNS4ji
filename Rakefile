require 'rubygems'
require 'bundler/setup'

require 'dm-core'
require 'dm-migrations'
require 'resque/tasks'

require 'lib/models'
require 'lib/jobs'

# set ENV for resque
ENV['COUNT'] = '2'
ENV['VVERBOSE'] = 'true'
ENV['QUEUE'] = 'hentaijks'

if ENV['RACK_ENV'] == 'production'
  DataMapper.setup(:default, ENV['DATABASE_URL'])
else
  DataMapper::Logger.new($stdout, :debug)
  #DataMapper.setup(:default, {:adapter => 'sqlite3', :database => 'db/development.db'})
  DataMapper.setup(:default, 'sqlite3:db/development.db')
end

namespace :db do
  task :migrate do
    DataMapper.auto_migrate!
  end
  task :update do
    DataMapper.auto_upgrade!
  end
end

namespace :jobs do
  task :enqueue do
    users = User.all
    users.each do |user|
      Resque.enqueue(TweetJob, user.access_token, user.access_token_secret)
    end
  end
end

#
# NOTE
#   rake task 'resque:worker' to start workers
#
