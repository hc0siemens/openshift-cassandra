#!/bin/bash -eu
#
# Doc: http://kubernetes.io/v1.1/examples/cassandra/README.html#tl-dr
#

if [[ ! -f ./cassandra.yaml ]]; then
	echo " "
	echo "Could not find cassandra setup files. To fetch these do:"	
	echo "   git clone https://github.com/kubernetes/kubernetes.git"
	echo "   cd kubernetes/examples/cassandra"
	echo " "
	echo "Then run this script from that location. :)"
	echo " "
	exit 1
fi

project_name=$(oc project -q)

echo "Running in project ${project_name}"

find -type f -name "*.yaml" -exec sed -i "s|gcr.io/google_containers/cassandra:v6|anderssv/openshift-cassandra-image:latest|g" {} \;

oc policy add-role-to-user view system:serviceaccount:${project_name}:default

oc create -f ./cassandra-service.yaml
oc create -f ./cassandra.yaml
oc create -f ./cassandra-controller.yaml

echo "Done!"
echo "Nodes are now launching..."
echo " "
echo "You might want to do:"
echo "   watch oc get pods # Monitor progress"
echo "   oc scale rc cassandra --replicas=10 # Scale and add more pods"
echo " "