FROM pcm32/kubespray-deps:v2.3.0

RUN apt-get update -y && apt-get install -y --no-install-recommends patch vim && \
    apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY ostack ostack
COPY run-deployment.sh run-deployment.sh
COPY run-destroy.sh run-destroy.sh
COPY set-kubeconfig.sh set-kubeconfig.sh
COPY image-settings.sh image-settings.sh
COPY patches patches
COPY run-helm-charts.sh run-helm-charts.sh
RUN patch -p0 -f < patches/kubespray-tf_secgroup_taints.patch
RUN chmod a+x set-kubeconfig.sh run-destroy.sh
COPY playbooks playbooks
RUN chmod u+x run-deployment.sh

