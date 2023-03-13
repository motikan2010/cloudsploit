# Build Dockerfile
build:
	docker compose build

# Exec CSPM
run:
	docker compose up

# Deploy to Amazon ECR
include .env
retag:
	docker tag $(IMAGE_NAME):$(IMAGE_TAG) $(shell aws cloudformation --region $(REGION) --profile $(PROFILE) describe-stacks --stack-name $(STACKNAME_BASE) --query "Stacks[0].Outputs[?OutputKey=='$(REPO_ID)'].OutputValue" --output text):$(IMAGE_TAG)
	aws ecr get-login-password --region $(REGION) --profile $(PROFILE) | docker login --username AWS --password-stdin $(shell aws cloudformation --region $(REGION) --profile $(PROFILE) describe-stacks --stack-name $(STACKNAME_BASE) --query "Stacks[0].Outputs[?OutputKey=='$(REPO_ID)'].OutputValue" --output text | cut -d '/' -f1)
	docker push $(shell aws cloudformation --region $(REGION) --profile $(PROFILE) describe-stacks --stack-name $(STACKNAME_BASE) --query "Stacks[0].Outputs[?OutputKey=='$(REPO_ID)'].OutputValue" --output text):$(IMAGE_TAG)

# Create CloudFormation stack
create-stack:
	aws cloudformation create-stack --template-body file://./cloudformation/template.yml --stack-name $(STACKNAME_BASE) --capabilities CAPABILITY_IAM \
	--parameters ParameterKey=MasterAwsAccessKeyId,ParameterValue=$(MASTER_AWS_ACCESS_KEY_ID) ParameterKey=MasterAwsSecretAccessKey,ParameterValue=$(MASTER_AWS_SECRET_ACCESS_KEY)

# Describe CloudFormation stack
describe-stacks:
	aws cloudformation describe-stacks --stack-name $(STACKNAME_BASE)
