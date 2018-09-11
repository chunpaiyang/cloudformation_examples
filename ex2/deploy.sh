#!/bin/sh

aws s3 mb s3://mybucket.yourname.com

aws cloudformation delete-stack --stack-name ex2
aws cloudformation package --template upload.template --s3-bucket mybucket.yourname.com --output-template-file upload_output.template
aws cloudformation deploy --template-file upload_output.template --stack-name ex2 --capabilities CAPABILITY_IAM
