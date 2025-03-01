
AWS_PROFILE ?=education

.PHONY: aws-login init

aws-login:
	aws-vault login ${AWS_PROFILE}

init: 
	aws-vault exec ${AWS_PROFILE} -- terraform init -backend-config=config/backend.conf

plan: init
	aws-vault exec ${AWS_PROFILE} -- terraform plan 

apply: init
	aws-vault exec ${AWS_PROFILE} -- terraform apply 