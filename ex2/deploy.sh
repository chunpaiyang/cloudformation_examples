#!/bin/bash -xe

stachName=""
aliasName="dev"
appSpecDir="tmp"
appSpecName="appspec.yml"
appSpecTemplateName="appspec.yml.template"
appSpecPath="${appSpecDir}/${appSpecName}"
appSpecTemplatePath="${appSpecDir}/${appSpecTemplateName}"

createAliasName()
{
    local functionName=$1
    local aliasName=$2
    local version=$3
    local grepAliasName=`aws lambda list-aliases --function-name ${functionName} | jq -r ".Aliases[] | select(.Name==\"$aliasName\").Name"`

    if [ "$aliasName" == "$grepAliasName" ]; then
        return 1
    fi

    aws lambda create-alias --function-name ${functionName} --name $aliasName --function-version $version
    return 0
}

sedAppspec()
{
    local functionName=$1
    local aliasName=$2
    local version=$3 # targetVersion

    local aliasNameVersion=`aws lambda list-aliases --function-name ${functionName} | jq -r ".Aliases[] | select(.Name==\"${aliasName}\").FunctionVersion"`

    sed -e "s:%LAMBDAFUNCTIONNAME%:${functionName}:g" \
        -e "s:%TARGETVERSION%:${version}:g" \
        -e "s:%ALIASNAME%:${aliasName}:g" \
        -e "s:%ALIASNAMEVERSION%:${aliasNameVersion}:g" ${appSpecTemplatePath} > ${appSpecPath}
}

deployWithAppspec()
{
    # use "dev" as deploy alias name
    aws s3 cp ${appSpecPath} s3://mybucket.yourname.com/${appSpecName}
    aws deploy register-application-revision --application-name LambdaCodeDeployTest  --s3-location bucket=mybucket.yourname.com,key=appspec.yml,bundleType=YAML
    aws deploy get-application-revision --application-name LambdaCodeDeployTest --s3-location bucket=mybucket.yourname.com,key=appspec.yml,bundleType=YAML
    aws deploy create-deployment --s3-location bucket=mybucket.yourname.com,key=appspec.yml,bundleType=YAML --application-name LambdaCodeDeployTest --deployment-group-name LambdaCodeDeployTest
}

# Step1. create s3 bucket
aws s3 mb s3://mybucket.yourname.com

# Step2. Upload code with cloudformation. Stackname is ex2
aws cloudformation package --template upload.template --s3-bucket mybucket.yourname.com --output-template-file upload_output.template
aws cloudformation deploy --template-file upload_output.template --stack-name ex2 --capabilities CAPABILITY_IAM

# get deploy lambda function name
fname=`aws cloudformation  describe-stacks --stack-name ex2 --query "Stacks[0].Outputs[0].OutputValue" --output text`

# get publish lambda function and get version
version=`aws lambda publish-version --function-name $fname | jq -r .Version`

# Step3. if "dev" alias name not exist create it and bind to the $LASTEST version of lambda
if createAliasName $fname $aliasName $version; then
    echo "first time deploy aliasName=${aliasName}"
    exit 0
fi

# Step4. deploy lambda function to "dev" by LambdaCodeDeployTest
sedAppspec $fname $aliasName $version
deployWithAppspec
