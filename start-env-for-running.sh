#mkdir -p keys

ENV_DEPLOY_DOCKER_IMAGE=${ENV_DEPLOY_DOCKER_IMAGE:-quay.io/pcm32/kubespray-ebi-portal:v2.3.0-ubuntu-xenial}

if [[ ! "$PROJECT_DIR" = /* ]]; then
	echo "PROJECT_DIR should be a full path to the directory where you have:"
	echo "- keys: folder with two files, key.pub and key.pem (public and private key)."
	echo "- deployments: optional folder, where deployments tfstate and ansible files will be stored"
	echo "- openstack.rc: OpenStack RC authentication file, you can obtain this through Horizon, API Access part."
	echo "- config.sh: Configuration for the deployment, can be made based on config.sh.sample"
	exit 1
fi

if [[ ! -e $PROJECT_DIR/keys/key.pub ]]; then
        echo "keys/key.pub doesn't exist inside Project directory $PROJECT_DIR."
	exit 1
fi

if [[ ! -e $PROJECT_DIR/keys/key.pem ]]; then
        echo "keys/key.pem doesn't exist inside Project directory $PROJECT_DIR."
	exit 1
fi

mkdir -p $PROJECT_DIR/deployments

if [[ ! -e $PROJECT_DIR/openstack.rc ]]; then
	echo "openstack.rc authentication file needs to be in the root of $PROJECT_DIR, with that name."
	exit 1
fi

if [[ ! -e $PROJECT_DIR/config.sh ]]; then
	echo "config.sh with your configuration for deployment needs to be in the root fo $PROJECT_DIR."
	exit 1
fi


MOUNT_STATE_DIR="-v $PROJECT_DIR/deployments:/cloud-deploy/deployments"
if [[ ! -z $STATE_DIR ]]; then
	MOUNT_STATE_DIR="-v $DEPLOYMENT_STATE_DIR:/cloud-deploy/deployments"
fi

DEPLOYMENT_CONFIG=$PROJECT_DIR/config.sh
MOUNT_DEPLOYMENT_CONFIG="-v $DEPLOYMENT_CONFIG:/cloud-deploy/config.sh"

OPENSTACK_RC=$PROJECT_DIR/openstack.rc

if [[ -z ${OPENSTACK_RC+x} ]]; then
	echo "OPENSTACK_RC env var needs to be defined and point to your openstack rc file."
	exit 1
fi

MOUNT_OPENSTACK_RC="-v $OPENSTACK_RC:/cloud-deploy/openstack.rc"

echo "Now execute to deploy:"
echo "$ run-deployment.sh"

MOUNT_ARTIFACTS="-v $PROJECT_DIR/artifacts:/cloud-deploy/artifacts"

docker run -v $PWD/keys:/cloud-deploy/keys $MOUNT_DEPLOYMENT_CONFIG \
	$MOUNT_STATE_DIR $MOUNT_OPENSTACK_RC $MOUNT_ARTIFACTS -it --entrypoint bash \
	$ENV_DEPLOY_DOCKER_IMAGE
