#!/bin/bash

cd "$( dirname $(realpath "${BASH_SOURCE[0]}") )"
source init.inc


aws s3 mb s3://${BUCKET} ${AWS_CLI_ARGS}
aws s3 ls s3://${BUCKET}/ ${AWS_CLI_ARGS}

git clone https://github.com/vmware/kube-fluentd-operator kfo

cd kfo

git remote add s3 s3://${BUCKET}

git push s3 master

cd ..

git init from-s3
cd from-s3
git remote add origin s3://${BUCKET}
git fetch origin
git checkout master
git branch -v