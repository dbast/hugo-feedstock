#!/bin/bash

set -ex

export GO111MODULE=on

cd $SRC_DIR
go build -ldflags "-s -w -X main.revision=conda-forge -X github.com/gohugoio/hugo/common/hugo.vendorInfo=conda-forge" -trimpath -v -o $PREFIX/bin/hugo
go-licenses save . --save_path ./library_licenses