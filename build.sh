#!/bin/bash

gox -osarch="linux/amd64 darwin/amd64" -output="dist/{{.OS}}_{{.Arch}}/{{.Dir}}"
