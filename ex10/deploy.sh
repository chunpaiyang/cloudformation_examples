#!/bin/bash -xe

aws s3 mb s3://mybucket.yourname.com
aws s3 cp openapi.yaml s3://openapi.yourname.com/openapi.yaml

zip -j tmp.zip tmp/*

aws cloudformation package --template upload.template --s3-bucket mybucket.yourname.com --output-template-file upload_output.template

aws cloudformation deploy --template-file upload_output.template --stack-name ex10 --capabilities CAPABILITY_IAM

