This is a simple set up for Cassandra with two nodes in a cluster.

# Create Cassandra cluster

    ./run.sh

# Start CQLSH

    oc exec -ti $(oc get -o jsonpath='{@.items[0].metadata.name}' pods) -- bash -c 'cqlsh $POD_IP 9042'

# List nodes with nodetool

    oc exec -ti $(oc get -o jsonpath='{@.items[0].metadata.name}' pods) -- nodetool status

# Test performance

WARNING: You normally don't want to launch this in the same pod as the Cassandra server (the below command does that). But if you want to just test it quick you can do this:

    oc exec -ti $(oc get -o jsonpath='{@.items[0].metadata.name}' pods) -- bash -c 'cassandra-stress write -node $POD_IP' | tee stress.txt

To launch it in a different pod:

    oc run cassandra-stress -i --tty --restart='Never' --image=anderssv/openshift-cassandra /bin/bash

Then run:
    
    cassandra-stress write -rate threads\>\=500 -node <pod_ip>

Make sure to check which node the cassandra-stress pod is running on, and that it is different from the nodes you are testing. :)

If you are disconnected from the pod run the following:

    oc attach -ti cassandra-stress

# Resources

- Cassandra tuning guide: https://tobert.github.io/pages/als-cassandra-21-tuning-guide.html
- Load testing and graphing: http://thelastpickle.com/blog/2015/10/23/cassandra-stress-and-graphs.html