require 'rubygems'
require 'bundler/setup'

require 'dm-core'
require 'dm-migrations'
require 'resque/tasks'

require 'setting'
require 'lib/models'
require 'lib/jobs'

APP_ROOT = File.dirname(__FILE__)

# for resque:workers
ENV['COUNT'] = WORKER_QUEUES.to_s
ENV['VVERBOSE'] = '1' if WORKER_VERBOSE
ENV['QUEUE'] = 'hentaijks'
#ENV['PIDFILE'] =  APP_ROOT + '/tmp/resque.pid'

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

namespace :workers do
  task :start do
    threads = []

    WORKER_QUEUES.times do |n|
      threads << Thread.new do
        pidfilepath = "#{APP_ROOT}/tmp/resque_#{n.to_s}.pid"
        ENV['PIDFILE'] = pidfilepath 
        system "rake resque:work"
      end
    end

    threads.each { |thread| thread.join }
  end

  task :stop do
    Dir.entries(APP_ROOT + '/tmp').each do |entry|
      if entry =~ /^resque_/
        pid = File.open(APP_ROOT + '/tmp/' + entry, 'r').read
        system "kill -QUIT #{pid}"
      end
    end
  end
end

#
# NOTE
#   rake task 'resque:workers' to start workers
#
