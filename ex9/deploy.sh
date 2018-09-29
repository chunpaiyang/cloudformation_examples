#!/bin/bash -xe

init() {
  aws s3 mb s3://mybucket.yourname.com

  zip -j tmp.zip tmp/*

  aws s3 cp tmp.zip s3://mybucket.yourname.com/tmp.zip

  sed -e "s:%APIGATEWAY%::g" upload.template.template > upload.template.tmp

  aws cloudformation package --template upload.template.tmp --s3-bucket mybucket.yourname.com --output-template-file upload_output.template

  aws cloudformation deploy --template-file upload_output.template --stack-name ex9 --capabilities CAPABILITY_IAM
}

deploy_api_gateway() {
  aws s3 mb s3://mybucket.yourname.com

  NameIntLambda=`aws cloudformation list-exports | jq '.Exports[] | select(.Name == "ex9StackIntLambdaName") | .Value'`


  sed -e "s#%NameIntLambda%#$NameIntLambda#g" openapi.yaml.template > openapi.yaml.tmp

  aws s3 cp openapi.yaml.tmp s3://openapi.yourname.com/openapi.yaml

  TOREPLACE='%APIGATEWAY%'
  sed -e "/$TOREPLACE/r apigateway.template" \
      -e "s/$TOREPLACE//g" \
      upload.template.template > upload.template.tmp

  aws cloudformation package --template upload.template.tmp --s3-bucket mybucket.yourname.com --output-template-file upload_output.template

  aws cloudformation deploy --template-file upload_output.template --stack-name ex9 --capabilities CAPABILITY_IAM

}

init
deploy_api_gateway
