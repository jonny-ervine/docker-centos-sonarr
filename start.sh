#!/bin/bash
##
## Start up script for sonarr on CentOS docker container
##

## Initialise any variables being called:
# Set the correct timezone
TZ=${TZ:-UTC}
USER=$USER
USERUID=$USERUID
setup=/config/.setup

if [ ! -f "${setup}" ]; then
  rm -f /etc/localtime
  cp /usr/share/zoneinfo/$TZ /etc/localtime
  adduser -u $USERUID $USER
  sed -i "s/user=/user=$USER/g" /etc/supervisord.d/sonarr.ini
  chown $USER:$USER /opt/sonarr
  touch $setup
fi

## Start up sonarr daemon via supervisord
/usr/bin/supervisord -n -c /etc/supervisord.conf
