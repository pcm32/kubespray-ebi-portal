#!/bin/bash

if ps -p $SSH_AGENT_PID > /dev/null
then
   echo "ssh-agent is already running"
   # Do something knowing the pid exists, i.e. the process with $PID is running
else
   source config.sh
   export PRIVATE_KEY="$PWD/keys/key.pem"
   eval $(ssh-agent -s)
   ssh-add $PRIVATE_KEY
fi

PORTAL_DEPLOYMENTS_ROOT=deployments

PUBLIC_IP=`awk -F'@' '{ print $2 }' $PORTAL_DEPLOYMENTS_ROOT'/'$PORTAL_DEPLOYMENT_REFERENCE/group_vars/no-floating.yml | sed s/\"\'//`

HOSTNAME=`ansible -b --become-user=root -i $PORTAL_DEPLOYMENTS_ROOT'/'$PORTAL_DEPLOYMENT_REFERENCE'/hosts' kube-master[0] -m setup -a 'filter=ansible_hostname' | grep ansible_hostname | awk -F':' '{ print $2}' | sed s/\"//g | sed -e 's/^[[:space:]]*//'`

sed -i 's+https://.*:6443+https://'"$HOSTNAME"':6443+' artifacts/admin.conf
echo "Add this line to your external /etc/hosts if needed:"
echo "$PUBLIC_IP $HOSTNAME"
echo "$PUBLIC_IP $HOSTNAME" >> /etc/hosts
