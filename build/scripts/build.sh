#!/usr/bin/env bash

set -e 

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do SOURCE="$(readlink "$SOURCE")"; done
SDIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
BDIR="$( cd -P "$( dirname "$SDIR" )/../.." && pwd )"

  BUILD_TIME=$(date +%s)
  TAG="current"
  REVISION="current"
  if hash git 2>/dev/null && [ -e ${BDIR}/.git ]; then
    TAG="$(git describe --tags 2>/dev/null || true)"
    [ -z "$TAG" ] && TAG="notag"
    REVISION=$(git rev-parse HEAD)
  fi

  LD_FLAGS="-s -w -X main.appBuildTime=${BUILD_TIME} -X main.appTag=${TAG} -X main.appRevision=${REVISION} -X main.appTag=${TAG}"

  mkdir -p ${BDIR}/bin

  pushd ${BDIR}/go-todo-rest-api-example/cmd/rest-server
  pwd
  CGO_ENABLED=0 go build -mod=vendor -trimpath -ldflags="${LD_FLAGS}" -a -tags 'netgo osusergo' -o ${BDIR}/go-todo-rest-api-example/bin/rest-server
  popd