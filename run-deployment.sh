#!/bin/bash
source $PWD/openstack.rc
source $PWD/config.sh
source $PWD/image-settings.sh


export TF_VAR_image=$BASE_IMAGE_NAME_PREFIX-$BASE_IMAGE_VERSION
export TF_VAR_ssh_user="ubuntu" # needs to be adequate to the BASE_IMAGE_SET

export TF_VAR_image_gfs=$BASE_IMAGE_NAME_PREFIX-$BASE_IMAGE_VERSION
export TF_VAR_ssh_user_gfs="ubuntu"

# Paths to public and private keys for the deployment
export PUBLIC_KEY="$PWD/keys/key.pub"
export PRIVATE_KEY="$PWD/keys/key.pem"

# Vars for the operation of the deployment
export PORTAL_DEPLOYMENTS_ROOT="$PWD/deployments"
export PORTAL_APP_REPO_FOLDER="$PWD"

export TF_VAR_public_key_path=$PUBLIC_KEY
export TF_VAR_cluster_name=$NAME


deployment_dir="$PORTAL_DEPLOYMENTS_ROOT/$PORTAL_DEPLOYMENT_REFERENCE"
if [[ ! -d "$deployment_dir" ]]; then
    mkdir -p "$deployment_dir"
fi
printf 'Using deployment directory "%s"\n' "$deployment_dir"

ostack/deploy.sh

cp -r kubespray/artifacts $PWD

./set-kubeconfig.sh
