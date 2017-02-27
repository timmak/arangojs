#!/bin/bash

# this scipt is required because the mocha framework does
# not take command line arguments for testing. So we have
# to resort to using the environment

# fist parameter is a valid connection url, --http or --vst
# second parameter can be --gdb to start mocha under gdb

http='http://127.0.0.1:8529'
vst='vst://127.0.0.1:8530'

#default to http
arangodb_url=${1:-$http}
case $arangodb_url in
    *'--http'*)
        arangodb_url="$http"
    ;;
    *'--vst'*)
        arangodb_url="$vst"
    ;;
esac

export TEST_ARANGODB_URL="$arangodb_url"
echo "using $TEST_ARANGODB_URL for testing"

# remove first parameter and pass
# remaining parameters unmodified
# to mocha
shift 1
./node_modules/mocha/bin/mocha "$@"
