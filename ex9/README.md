# Target:
- This example shows how to
  integrate with OpenAPI with seperated file(use BodyS3Location)
  and create a integrated POST API 

# How to use:
- Execute deploy.sh

# NOTE:
- After deploy, you can use curl to invoke this apigateway:
  'curl -X POST https://[apigatewayid].execute-api.[region].amazonaws.com/dev'
- This example is really hard.
  - 1. The AWS design for BodyS3Location is strange.
    I need to get 'integration name of lambda' and 'put into openapi.template'
    ,so that I need to deploy twice. First time for lambda deployment only,
    and second time for apigateway deployment.

    Use this method to workaround the need of name of lambda name,
    the second time deployment can get first time's lambda name.

  - 2. The better way shall be to use 'AWS::Include Transform',
    if you want to sepearte cloudformation template and openapi template:
    let cloudformation template to include openapi template.
