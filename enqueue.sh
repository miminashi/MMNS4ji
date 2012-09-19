#!/bin/sh
{
  cd /home/miminashi/apps/haruyabirthday
  /var/lib/gems/1.8/bin/bundle exec rake jobs:enqueue RACK_ENV=production DATABASE_URL='sqlite3:db/production.db'
}
