mkdir -p keys

if [[ ! "$PUBLIC_KEY" = /* ]]; then
	echo "PUBLIC_KEY should be a full path to the public key"
	exit 1
fi

if [[ ! "$PRIVATE_KEY" = /* ]]; then
	echo "PRIVATE_KEY should be a full path to the private pem key"
	exit 1
fi


cp $PUBLIC_KEY keys/key.pub
cp $PRIVATE_KEY keys/key.pem

MOUNT_STATE_DIR="-v $PWD/deployments:/cloud-deploy/deployments"
if [[ ! -z $STATE_DIR ]]; then
	MOUNT_STATE_DIR="-v $DEPLOYMENT_STATE_DIR:/cloud-deploy/deployments"
fi

if [[ -z ${DEPLOYMENT_CONFIG+x} ]]; then
	echo "DEPLOYMENT_CONFIG env var needs to be defined and point to your config file."
	exit 1
fi

MOUNT_DEPLOYMENT_CONFIG="-v $DEPLOYMENT_CONFIG:/cloud-deploy/config.sh"

if [[ -z ${OPENSTACK_RC+x} ]]; then
	echo "OPENSTACK_RC env var needs to be defined and point to your openstack rc file."
	exit 1
fi

MOUNT_OPENSTACK_RC="-v $OPENSTACK_RC:/cloud-deploy/openstack.rc"

echo "Now execute to deploy:"
echo "$ run-deployment.sh" 

docker run -v $PWD/keys:/cloud-deploy/keys $MOUNT_DEPLOYMENT_CONFIG \
	$MOUNT_STATE_DIR $MOUNT_OPENSTACK_RC -it --entrypoint bash \
	pcm32/kubespray-ebi-portal:v2.3.0_cv0.1.0
