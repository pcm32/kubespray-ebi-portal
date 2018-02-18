## OS images for k8s and glusterfs
# This image is currently uploaded if not in the project.
## Base image to use, currently the same for Kubernetes machines and GFS. Probably should move inside.
export BASE_IMAGE_VERSION="current"
export BASE_IMAGE_URL="https://cloud-images.ubuntu.com/xenial/$BASE_IMAGE_VERSION/xenial-server-cloudimg-amd64-disk1.img"
export BASE_IMAGE_NAME_PREFIX="Ubuntu-16.04"
