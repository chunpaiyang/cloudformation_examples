# How to use:
- step1. Change S3 bucket name to another unique name:
    - edit mybucket.yourname.com in deploy.sh

- step2. Create codedeploy App/Group with App name LambdaCodeDeployTest and Group name LambdaCodeDeployTest.
- step3. execute deploy.sh

# What deploy.sh do ?
    - Step1. create s3 bucket
    - Step2. Upload code to this bucket with cloudformation. Stackname is ex2.
    - Step3. create "dev" alias name for lambda if "dev" alias name not exist else
    - Step4. deploy lambda function to "dev" by codedeploy App/Group LambdaCodeDeployTest/LambdaCodeDeployTest(you must create this App/Group by yourself, this script not handle this part)

