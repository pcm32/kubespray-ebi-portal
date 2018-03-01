export KUBECONFIG=artifacts/admin.conf
helm init --upgrade
echo "Waiting for helm setup..."
sleep 30

if [ ! -d applications ]; then
	echo "No directory 'applications', will stop here and not execute helm deployments"
fi

cd applications
for app in `ls run-*`; do
	bash $app
done
