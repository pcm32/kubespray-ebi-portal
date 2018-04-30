#!/usr/bin/env bash
set -e
# Destroys Kubespray deployment 
# The script assumes that env vars for authentication with OpenStack are already present.

## Customise this ##
export PORTAL_APP_REPO_FOLDER="$PWD"
export KARGO_TERRAFORM_FOLDER=$PORTAL_APP_REPO_FOLDER'/kubespray/contrib/terraform/openstack'
export TF_VAR_DEPLOYMENT_KEY_PATH=$PORTAL_DEPLOYMENTS_ROOT'/'$PORTAL_DEPLOYMENT_REFERENCE'/'$PORTAL_DEPLOYMENT_REFERENCE'.pub'

# Destroy everything
#cd ostack/terraform || exit
cd $PORTAL_APP_REPO_FOLDER'/kubespray'
#terraform plan --state=$PORTAL_DEPLOYMENTS_ROOT'/'$PORTAL_DEPLOYMENT_REFERENCE'/terraform.tfstate' $KARGO_TERRAFORM_FOLDER
terraform init $KARGO_TERRAFORM_FOLDER
terraform destroy --force --input=false --state=$PORTAL_DEPLOYMENTS_ROOT'/'$PORTAL_DEPLOYMENT_REFERENCE'/terraform.tfstate'
