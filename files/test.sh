#!/bin/bash
set -e
terraform fmt -write=false ./examples/azure-vm-with-ppro
cd ./test
go test -v -timeout 30m