#!/bin/sh
EXEC_USER=miminashi
APP_ROOT=/home/$EXEC_USER/apps/haruyabirthday
export PATH=$PATH:/home/$EXEC_USER/.rbenv/shims:/home/$EXEC_USER/.rbenv/bin
cd $APP_ROOT
bundle exec unicorn -D -E production -c ${APP_ROOT}/config/unicorn.conf

#sudo -u miminashi /var/lib/gems/1.8/bin/unicorn -D -E production -c ${APPHOME}/unicorn.conf ${APPHOME}/config.ru
