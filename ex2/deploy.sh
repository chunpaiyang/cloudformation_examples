#!/bin/sh

aws s3 cp tmp/appspec.yml s3://mybucket.yourname.com/appspec.yml
aws deploy register-application-revision --application-name LambdaCodeDeployTest  --s3-location bucket=mybucket.yourname.com,key=appspec.yml,bundleType=YAML
aws deploy get-application-revision --application-name LambdaCodeDeployTest --s3-location bucket=mybucket.yourname.com,key=appspec.yml,bundleType=YAML
aws deploy create-deployment --s3-location bucket=mybucket.yourname.com,key=appspec.yml,bundleType=YAML --application-name LambdaCodeDeployTest --deployment-group-name LambdaCodeDeployTest
