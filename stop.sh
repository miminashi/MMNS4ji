#!/bin/sh
EXEC_USER=miminashi
APP_ROOT=/home/$EXEC_USER/apps/haruyabirthday
kill -QUIT `cat $APP_ROOT/tmp/pid/unicorn.pid`
