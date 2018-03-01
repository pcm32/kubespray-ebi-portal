#!/bin/bash

source config.sh
export PRIVATE_KEY="$PWD/keys/key.pem"
eval $(ssh-agent -s)
ssh-add $PRIVATE_KEY

PORTAL_DEPLOYMENTS_ROOT=deployments

PUBLIC_IP=`awk -F'@' '{ print $2 }' $PORTAL_DEPLOYMENTS_ROOT'/'$PORTAL_DEPLOYMENT_REFERENCE/group_vars/no-floating.yml | sed s/\"\'//`

# we need to avoid the trusted key prompt
HOSTNAME=`ansible -b --become-user=root -i $PORTAL_DEPLOYMENTS_ROOT'/'$PORTAL_DEPLOYMENT_REFERENCE'/hosts' kube-master[0] -m setup -a 'filter=ansible_hostname' | grep ansible_hostname | awk -F':' '{ print $2}' | sed s/\"//g | sed -e 's/^[[:space:]]*//'`

sed -i 's+https://.*:6443+https://'"$HOSTNAME"':6443+' /cloud-deploy/artifacts/admin.conf
echo "Add this line to your external /etc/hosts if needed:"
echo "$PUBLIC_IP $HOSTNAME"
echo "$PUBLIC_IP $HOSTNAME" >> /etc/hosts
echo "$PUBLIC_IP $HOSTNAME" >> /cloud-deploy/artifacts/to-add-to-your-etc-hosts

echo "Execute the following line in this shell to connect to your cluster through kubectl:"
echo "export KUBECONFIG=/cloud-deploy/artifacts/admin.conf"
echo ""
echo "To connect through ssh:"
echo "ssh -i keys/key.pem ubuntu@$PUBLIC_IP"
echo "ssh -i keys/key.pem ubuntu@$PUBLIC_IP" >> /cloud-deploy/artifacts/ssh-connect

