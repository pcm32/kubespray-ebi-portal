#!/bin/bash
source $PWD/openstack.rc
source $PWD/config.sh

# Vars for the operation of the deployment
export PORTAL_APP_REPO_FOLDER="$PWD"
export PORTAL_DEPLOYMENTS_ROOT=$PWD/deployments

bash ostack/destroy.sh
