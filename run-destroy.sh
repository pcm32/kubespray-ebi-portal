#!/bin/bash
source $PWD/openstack.rc
source $PWD/config.sh

# Vars for the operation of the deployment
export PORTAL_DEPLOYMENTS_ROOT=$PWD/deployments

bash ostack/destroy.sh
