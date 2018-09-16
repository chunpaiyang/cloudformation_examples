#!/bin/bash -xe

# Step1. create s3 bucket
aws s3 mb s3://mybucket.yourname.com

zip -j tmp.zip tmp/*

# Step2. Upload code with cloudformation.
aws cloudformation package --template upload.template --s3-bucket mybucket.yourname.com --output-template-file upload_output.template
aws cloudformation deploy --template-file upload_output.template --stack-name ex3 --capabilities CAPABILITY_IAM

