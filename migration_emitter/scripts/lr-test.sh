#!/usr/bin/env bash

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#Set env variables from jruby install
source /etc/profile.d/jruby.sh

#ADD REMOVE OLD RESULTS

cd $dir/../tests/MintEmitter
cucumber -f pretty -f junit -o .

exit 0