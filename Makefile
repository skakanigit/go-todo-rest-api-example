

BUILD_TAG=$(shell git rev-parse --short HEAD)
ECR_REGISTRY=713881804011.dkr.ecr.us-east-2.amazonaws.com
IMAGE_NAME=${ECR_REGISTRY}/rest-api-server-repository
AWS_PROFILE ?=education

.PHONY: aws-login
aws-login:
	aws-vault login ${AWS_PROFILE}

.PHONY: build-local
build-local:
	'$(CURDIR)/build/scripts/build.sh'

.PHONY: run-local
run-local:
	'$(CURDIR)/build/scripts/run.sh'

.PHONY: build-container
build-container:
	docker build --rm  \
	-t $(IMAGE_NAME):$(BUILD_TAG) \
	-t $(IMAGE_NAME):latest \
	-f Dockerfile $(CURDIR)

.PHONY: run-container
run-container: 
	docker run -p 3000:3000 \
	 --add-host=host.docker.internal:host-gateway \
	 ${IMAGE_NAME}:${BUILD_TAG}

.PHONY: push-container
push-container: build-container
	aws-vault exec ${AWS_PROFILE} --no-session -- aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin ${ECR_REGISTRY}
	aws-vault exec ${AWS_PROFILE} --no-session -- docker push ${IMAGE_NAME}:${BUILD_TAG}
	aws-vault exec ${AWS_PROFILE} --no-session -- docker push ${IMAGE_NAME}:latest

.PHONY: build-run-container
build-run-container: run-container

.PHONY: eks-login
eks-login:
	aws-vault exec ${AWS_PROFILE} -- aws eks --region us-east-2 update-kubeconfig --name education-eks-bRrGwzaS
	kubectl config set-context  --current --namespace=default

.PHONY: service-deploy-eks
service-deploy-eks:
	aws-vault exec ${AWS_PROFILE} -- helm upgrade --install \
	go-rest-server-helm-deployment $(CURDIR)/infra/helm/go-rest-server \
	--namespace=default

.PHONY: service-delete-eks
service-delete-eks:
	aws-vault exec ${AWS_PROFILE} -- helm delete go-rest-server-helm-deployment --namespace=default