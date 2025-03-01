#!/usr/bin/env bash

set -e 

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do SOURCE="$(readlink "$SOURCE")"; done
SDIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
BDIR="$( cd -P "$( dirname "$SDIR" )/../.." && pwd )"

pushd ${BDIR}/go-todo-rest-api-example/bin
pwd
./rest-server