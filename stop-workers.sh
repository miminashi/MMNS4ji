#!/bin/sh
APPROOT=/home/miminashi/apps/haruyabirthday
{
  cd ${APPROOT}
  sudo -u miminashi /var/lib/gems/1.8/bin/bundle exec rake workers:stop
}
