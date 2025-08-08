LAMBDA_DIR=./lambda
TERRAFORM_DIR=./terraform

.PHONY: all build deploy clean

all: build deploy

build:
	cd $(LAMBDA_DIR) && \
	zip -r main_handler.zip main_handler.py && \
	zip -r failure_handler.zip failure_handler.py

deploy:
	cd $(TERRAFORM_DIR) && terraform init && terraform apply -auto-approve

clean:
	rm -f $(LAMBDA_DIR)/*.zip
	cd $(TERRAFORM_DIR) && terraform destroy -auto-approve
