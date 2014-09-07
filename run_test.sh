#!/bin/sh
for script in tests/*.sh
do
    set -e -x
    $script
    set +x
done
