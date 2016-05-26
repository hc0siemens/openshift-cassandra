This is a simple set up for Cassandra with two nodes in a cluster.

# Create Cassandra cluster

    ./run.sh

# Start CQLSH

    oc exec -ti $(oc get -o jsonpath='{@.items[0].metadata.name}' pods) -- bash -c 'cqlsh $POD_IP 9042'

# List nodes with nodetool

    oc exec -ti $(oc get -o jsonpath='{@.items[0].metadata.name}' pods) -- nodetool status

# Test performance

Cassandra has a build in stress test tool that is awesome.

## Demo mode

You can easily run the benchmarks inside the same pod as one of the server processes. You normally don't want to do this though as it affects the server process and is constrained to the same cpu and memory as the server.

    oc exec -ti $(oc get -o jsonpath='{@.items[0].metadata.name}' pods) -- bash -c 'cassandra-stress write -node $POD_IP' | tee stress.txt

## Stress testing pod
To launch it in a different pod:

    oc run cassandra-stress -i --tty --attach=false --image=anderssv/openshift-cassandra /bin/bash

Running the test:
    
    oc exec \
        -t $(oc get -l 'run=cassandra-stress' -o jsonpath='{@.items[0].metadata.name}' pods) \
        -- cassandra-stress write -rate threads\>\=500 \
            -node $(oc get -o jsonpath='{@.items[0].status.podIP}' pods) \
            -graph file=/tmp/openshift-benchmark.html title=Openshift revision=benchmark-0

This will display stats but also generate a HTML report. To extract the report from the pod you can do:

    mkdir -p /tmp/openshift-cassandra-report \
    && oc rsync \
        $(oc get -l 'run=cassandra-stress' -o jsonpath='{@.items[0].metadata.name}' pods):/tmp /tmp/openshift-cassandra-report

Make sure to check which node the cassandra-stress pod is running on, and that it is different from the nodes you are testing. :)

# Resources

- Cassandra tuning guide: https://tobert.github.io/pages/als-cassandra-21-tuning-guide.html
- Load testing and graphing: http://thelastpickle.com/blog/2015/10/23/cassandra-stress-and-graphs.html