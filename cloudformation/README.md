
## CloudFormation

### Create Stack

```
aws cloudformation create-stack --template-body file://./template.yml --stack-name cloudsploit-stack --capabilities CAPABILITY_IAM \
    --parameters ParameterKey=MasterAwsAccessKeyId,ParameterValue=AKIAXXXXX ParameterKey=MasterAwsSecretAccessKey,ParameterValue=XXXXX
```

### Update Stack

```
aws cloudformation update-stack --template-body file://./template.yml --stack-name cloudsploit-stack --capabilities CAPABILITY_IAM \
    --parameters ParameterKey=MasterAwsAccessKeyId,ParameterValue=AKIAXXXXX ParameterKey=MasterAwsSecretAccessKey,ParameterValue=XXXXX
```

### Delete Stack

```
aws cloudformation delete-stack --stack-name cloudsploit-stack
```
