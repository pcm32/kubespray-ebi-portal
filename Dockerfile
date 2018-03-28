FROM pcm32/kubespray-deps:v2.4.0-bastion-fix

RUN apt-get update -y && apt-get install -y --no-install-recommends vim && \
    apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#RUN terraform init kubespray/contrib/terraform/openstack
COPY ostack ostack
COPY run-deployment.sh run-deployment.sh
COPY run-destroy.sh run-destroy.sh
COPY set-kubeconfig.sh set-kubeconfig.sh
COPY image-settings.sh image-settings.sh
COPY run-helm-charts.sh run-helm-charts.sh
RUN chmod a+x set-kubeconfig.sh run-destroy.sh
COPY playbooks playbooks
RUN chmod u+x run-deployment.sh

