# Deployment of Kubernetes + shared file system

## Requirements

- docker
- ability to generate ssh private and public keys
- openstack RC API access file, from Horizon
- a written config for the deployment

## How to use

Assemble a folder in your machine with the following files:

- `keys`: a folder named `keys` containing key.pub and key.pem (for the private key)
- `openstack.rc`: OpenStack API access RC file
- `config.sh`: Bash file with configuration for the deployment (flavours for instances, number of master, etc, see config.sh.sample)

If not available, two folders will be created:

- `artifacts`: where relevant files are left to access to the cluster, for instance the kubeconfig file for the new cluster, for direct queries from kubectl.
- `deployments`: terraform state for deployments and other ansible configs.

Then export an environment variable named `$PROJECT_DIR` pointing to this directory:

```
export PROJECT_DIR=/full/path/to/my/deployment/project
```

Keep this directory safe, as it will keep the state of your deployed cluster, config file and keys, which are relevant for accessing it, modifying it or destroying it.

Finally, to run it:

$ bash start-env-for-running.sh

Then inside the container, execute ./run-deployment.sh

After some 20 minutes it should provide you with access instructions for both `kubectl` and `ssh`. 

Hint: if possible, limit all your interaction with the cluster through `kubectl`, which will make this cluster more easily "disposable". 
