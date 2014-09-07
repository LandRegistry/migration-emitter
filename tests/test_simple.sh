#!/bin/bash

# TBD use a test harness, rather than this shell script!
function error() {
    echo "$0: FAIL"
}

trap error EXIT
mkdir -p tmp

data=tests/fixtures/simple.yml
title=tmp/simple_output.json

set -e -x
# TBD call an emitter library, rather than running the template ..
bin/erb.rb -y $data templates/title.json.erb > $title

# TBD make the title more, er, complete!
diff $title - <<-!
{
    "title_number": "TEST1234567"
}
!

# TBD validate using the python datatypes validator ..

set +x
trap - EXIT
echo "$0: OK"
