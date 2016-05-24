# Create Cassandra cluster

    ./run.sh

# Test performance

    oc exec -ti $(oc get -o jsonpath='{@.items[0].metadata.name}' pods) -- bash -c 'cassandra-stress write -node $POD_IP' | tee stress.txt

# Start CQLSH

    oc exec -ti $(oc get -o jsonpath='{@.items[0].metadata.name}' pods) -- bash -c 'cqlsh $POD_IP 9042'

# List nodes with nodetool

    oc exec -ti $(oc get -o jsonpath='{@.items[0].metadata.name}' pods) -- nodetool status