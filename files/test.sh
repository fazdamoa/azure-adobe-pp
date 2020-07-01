#!/bin/bash
set -e
terraform fmt -write=false ./examples/azure-vm-with-ppro
cd ./test
go get -d
#go mod init github.com/fazdamoa/azure-adobe-pp
go test -v -timeout 30m