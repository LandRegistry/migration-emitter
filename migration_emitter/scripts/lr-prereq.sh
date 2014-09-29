#!/usr/bin/env bash

# Install JRuby and packages
yum -y install java-1.7.0-openjdk-headless
yum -y install jruby
yum -y install jrubygem-cucumber jrubygem-jbuilder \
			   jrubygem-json jrubygem-rest_client jrubygem-torquebox jrubygem-torquebox-backstage jrubygem-torquebox-server jrubygem-torquespec \
			   jrubygem-json_spec

#Set env variables from jruby install
source /etc/profile.d/jruby.sh

#Set env variables from torquebox gem
export `torquebox env`

#Add torquebox user and give access to jboss folder
adduser torquebox
chown torquebox.torquebox -R $JBOSS_HOME
#Give torquebox user access to backstage folder as well since this seems to be necessary
chown torquebox.torquebox -R $TORQUEBOX_HOME/../torquebox-backstage-1.1.0

#Set up init script
#Get directory of script to use paths
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cp $dir/torquebox /etc/init.d
chmod 0755 /etc/init.d/torquebox
chkconfig --add torquebox
chkconfig torquebox on

#Open firewall for torquebox
firewall-cmd --add-port=8080/tcp --permanent
firewall-cmd --reload

#Start torquebox
service torquebox start
