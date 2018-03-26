#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
# (but allow for the error trap)
set -eE

# keys exists at $PUBLIC_KEY, $PRIVATE_KEY and profile key at $ssh_key
export TF_VAR_public_key_path=$PUBLIC_KEY

eval $(ssh-agent -s)
ssh-add $PRIVATE_KEY

echo Setting up Terraform creds && \
  export TF_VAR_username=${OS_USERNAME} && \
  export TF_VAR_password=${OS_PASSWORD} && \
  export TF_VAR_tenant=${OS_TENANT_NAME} && \
  export TF_VAR_auth_url=${OS_AUTH_URL}

# make sure image is available in openstack
#ansible-playbook "$PORTAL_APP_REPO_FOLDER/playbooks/import-openstack-image.yml"
ansible-playbook "$PORTAL_APP_REPO_FOLDER/playbooks/import-openstack-image.yml" \
	-e img_version=$BASE_IMAGE_VERSION \
        -e img_prefix=$BASE_IMAGE_NAME_PREFIX \
	-e url=$BASE_IMAGE_URL \
        -e compress_suffix=""


export KARGO_TERRAFORM_FOLDER=$PORTAL_APP_REPO_FOLDER'/kubespray/contrib/terraform/openstack'



cd $PORTAL_APP_REPO_FOLDER'/kubespray'
#terraform plan --state=$PORTAL_DEPLOYMENTS_ROOT'/'$PORTAL_DEPLOYMENT_REFERENCE'/terraform.tfstate' $KARGO_TERRAFORM_FOLDER
terraform init $KARGO_TERRAFORM_FOLDER
terraform apply --state=$PORTAL_DEPLOYMENTS_ROOT'/'$PORTAL_DEPLOYMENT_REFERENCE'/terraform.tfstate' $KARGO_TERRAFORM_FOLDER

cp contrib/terraform/terraform.py $PORTAL_DEPLOYMENTS_ROOT'/'$PORTAL_DEPLOYMENT_REFERENCE'/hosts'
cp -r inventory/group_vars $PORTAL_DEPLOYMENTS_ROOT'/'$PORTAL_DEPLOYMENT_REFERENCE'/'

echo "Sleeping for 30 seconds to wait for startup"
sleep 30

# Provision kubespray
ansible-playbook -b --become-user=root -i $PORTAL_DEPLOYMENTS_ROOT'/'$PORTAL_DEPLOYMENT_REFERENCE'/hosts' cluster.yml \
	--key-file "$PRIVATE_KEY" \
	-e bootstrap_os=ubuntu \
	-e host_key_checking=false \
	-e cloud_provider="openstack" \
	-e '{ efk_enabled: False }' \
        -e kubelet_deployment_type=$KUBELET_DEPLOYMENT_TYPE \
	-e kube_api_pwd=$TF_VAR_kube_api_pwd \
	-e cluster_name=$TF_VAR_cluster_name \
	-e '{ helm_enabled: True }' \
	-e '{ kubeconfig_localhost: True }' \
	-e kube_network_plugin="flannel"


#       -e kube_version=$KUBE_VERSION \


# Provision glusterfs
ansible-playbook -b --become-user=root -i $PORTAL_DEPLOYMENTS_ROOT'/'$PORTAL_DEPLOYMENT_REFERENCE'/hosts' ./contrib/network-storage/glusterfs/glusterfs.yml \
	--key-file "$PRIVATE_KEY" \
	-e host_key_checking=false \
	-e bootstrap_os=ubuntu



# Add provided public key
#ansible-playbook -b --become-user=root -i $PORTAL_DEPLOYMENTS_ROOT'/'$PORTAL_DEPLOYMENT_REFERENCE'/hosts' --key-file "$PRIVATE_KEY" \
#	-e injected_public_key=$ssh_key

# TODO
# - Make sure that glusterfs nodes get bootstrapped if needed (link bootstrap roles if needed)
# - Add service that mimicks endpoint for glusterfs to avoid the endpoint going missing.

# We need to copy the no-ip yaml files for ansible to somewhere sensible
#terraform apply -state=contrib/terraform/openstack/terraform.tfstate -var-file=phenomenal-test-deploy.tfvars contrib/terraform/openstack
