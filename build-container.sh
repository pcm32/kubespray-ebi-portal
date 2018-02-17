DOCKERUSER=${DOCKERUSER:-pcm32}

docker build -t $DOCKERUSER/kubespray-ebi-portal:v2.3.0_cv0.1.0 .
docker push $DOCKERUSER/kubespray-ebi-portal:v2.3.0_cv0.1.0 
