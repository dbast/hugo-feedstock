#!/bin/bash

set -ex

export GO111MODULE=on
export CGO_ENABLED=1

if [ "$(uname -m)" = "ppc64le" ]; then
    export CFLAGS="$CFLAGS -ffunction-sections -fdata-sections --gc-sections -mcmodel=medium -fno-lto"
    export LDFLAGS="$LDFLAGS -ffunction-sections -fdata-sections --gc-sections -mcmodel=medium -fno-lto"
    export CXXFLAGS="$CXXFLAGS -ffunction-sections -fdata-sections --gc-sections -mcmodel=medium -fno-lto"
    # -fno-lto -flto -fno-tree-vectorize
    # export CGO_CFLAGS="-mcmodel=large"
    # export CGO_LDFLAGS="-mcmodel=large"
fi

env | sort

cd $SRC_DIR
go build -ldflags "-s -w -X main.revision=conda-forge -X github.com/gohugoio/hugo/common/hugo.vendorInfo=conda-forge" -tags extended -trimpath -v -o $PREFIX/bin/hugo
go-licenses save . --save_path ./library_licenses
chmod -R u+w $(go env GOPATH) && rm -r $(go env GOPATH)
