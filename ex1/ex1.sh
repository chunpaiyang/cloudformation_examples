#!/bin/sh
aws cloudformation delete-stack --template-body file://ex1.template --stack-name ex1 --capabilities CAPABILITY_IAM
aws cloudformation create-stack --template-body file://ex1.template --stack-name ex1 --capabilities CAPABILITY_IAM
