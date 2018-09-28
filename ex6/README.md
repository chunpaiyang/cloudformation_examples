# Target:
- This example shows how to
  completely create a apigateway for lambda

# How to use:
- Execute deploy.sh

# Note:
- The stage name of apiGatewayDeploymentStage in upload.template 
can't be change unless you change the resource name: apiGatewayDeploymentStage.
- After deployed, you can use 'curl -X POST https://[your apigateway path]'
to test.
