#!/bin/bash -eu
#
# Doc: http://kubernetes.io/v1.1/examples/cassandra/README.html#tl-dr
#

project_name=$(oc project -q)

echo "Running in project ${project_name}"

oc policy add-role-to-user view system:serviceaccount:${project_name}:default

oc create -f ./persistent-volume/cassandra-service.yaml
oc create -f ./persistent-volume/cassandra-controller.yaml

echo "Done!"
echo "Nodes are now launching..."
echo " "
echo "You might want to do:"
echo "   watch oc get pods # Monitor progress"
echo "   oc scale rc cassandra --replicas=10 # Scale and add more pods"
echo " "