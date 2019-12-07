TAG := aws/codebuild/standard:2.0
yml := buildspec.yml

terraform-init:
	cd terraform && \
	terraform init

terraform-apply:
	cd terraform && \
	terraform apply

terraform-destroy:
	cd terraform && \
	terraform destroy

codebuild-local-clone:
	git clone --depth 1 https://github.com/aws/aws-codebuild-docker-images.git -b 19.11.26 docker-images

codebuild-local-build:
	cd docker-images && \
		cd ubuntu/standard/2.0 && \
		docker build -t $(TAG) .

codebuild-local-pull:
	docker pull amazon/aws-codebuild-local:latest --disable-content-trust=false

codebuild-local-init: codebuild-local-clone codebuild-local-build codebuild-local-pull

test:
	./docker-images/local_builds/codebuild_build.sh \
		-c \
		-e codebuild_local.env \
		-i $(TAG) \
		-a artifact \
		-b $(yml)
