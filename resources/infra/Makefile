# SPDX-FileCopyrightText: © 2025 Menacit AB <foss@menacit.se>
# SPDX-License-Identifier: CC-BY-SA-4.0

# Use Podman for running the "tool container" if available, otherwise Docker
ifeq ($(shell command -v podman &> /dev/null),)
	CONTAINER_TOOL=docker
else
	CONTAINER_TOOL=podman
endif

# Use image inspect to ensure that specified image exist locally
IMAGE_NAME:=k8s_sec-cm:latest
RUN_PREFIX:=${CONTAINER_TOOL} image inspect ${IMAGE_NAME} 1> /dev/null \
	|| ${CONTAINER_TOOL} build -t ${IMAGE_NAME} -f Containerfile . \
	&& ${CONTAINER_TOOL} run \
		--rm -i -t -v ${PWD}:/data -v ${PWD}/_conf:/etc/openstack \
		-e TF_DATA_DIR=/data/_state/tf_data \
		-e ANSIBLE_RETRY_FILES_ENABLED=0 \
		-e OS_CLOUD=openstack \
		${IMAGE_NAME}

TF_BASE_SUFFIX:=-var-file=_conf/main.tfvars

# Configure limit for playbook execution - "make TARGET_LIMIT=workers"
TARGET_LIMIT:=all

# Specify lab environment scenario
SCENARIO:=none

.PHONY: tofu_plan tofu_apply tofu_destroy ping pre_deploy deploy post_deploy shell clean
all: tofu_apply pre_deploy deploy post_deploy

tofu_plan:
	${RUN_PREFIX} tofu init
	${RUN_PREFIX} tofu plan ${TF_BASE_SUFFIX}
	
tofu_apply:
	${RUN_PREFIX} tofu init
	${RUN_PREFIX} tofu apply ${TF_BASE_SUFFIX} -auto-approve

tofu_destroy:
	${RUN_PREFIX} tofu init
	${RUN_PREFIX} tofu destroy ${TF_BASE_SUFFIX} -auto-approve

ping:
	${RUN_PREFIX} ansible -i _state/inventory "${TARGET_LIMIT}" -m ping

include pre_deploy.mk

deploy:
	${RUN_PREFIX} ansible-playbook \
		-vv -i _state/inventory -l "${TARGET_LIMIT}" -e "lab_scenario=${SCENARIO}" site.yml

include post_deploy.mk

shell:
	${RUN_PREFIX} bash

clean:
	${RUN_PREFIX} tofu destroy ${TF_BASE_SUFFIX} -auto-approve
	rm -rf _state/*
	docker image rm ${IMAGE_NAME}
