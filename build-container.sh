DOCKERUSER=${DOCKERUSER:-pcm32}

docker build -t $DOCKERUSER/kubespray-ebi-portal:v2.4.0-bastion-fix_cv0.1.0 .
docker push $DOCKERUSER/kubespray-ebi-portal:v2.4.0-bastion-fix_cv0.1.0 
