#!/bin/bash -xe

aws cloudformation deploy --template-file upload.template --stack-name ex4 --capabilities CAPABILITY_IAM

