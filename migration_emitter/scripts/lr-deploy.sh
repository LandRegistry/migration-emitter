#!/usr/bin/env bash

#Check environment setting and default to development
if [ -z "$MIGRATOR_ENVIRONMENT" ]
then
	env="development"
else
	env="$MIGRATOR_ENVIRONMENT"
fi

#Get directory of script to use paths
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#Set env variables from jruby install
source /etc/profile.d/jruby.sh

#Set env variables from torquebox gem
export `torquebox env`

#undeploy everything
torquebox undeploy MintEmitter

#deploy apps

torquebox deploy --env=$env $dir/../apps/MintEmitter

echo "MintEmitter deployed"

#Restart just to ensure everything's OK
service torquebox restart