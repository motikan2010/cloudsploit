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
