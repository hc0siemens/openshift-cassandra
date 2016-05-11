#!/bin/bash

# Copyright 2014 The Kubernetes Authors All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

perl -pi -e "s/%%ip%%/$(hostname -I)/g" /etc/cassandra/cassandra.yaml
export CLASSPATH=/kubernetes-cassandra.jar
export BOOT_LOG=/cassandra_data/boot.log # Does not show up at stdout???


echo "Starting Cassandra node" > $BOOT_LOG
echo "--------------------------------------------------" >> $BOOT_LOG
ls -la /cassandra_data >> $BOOT_LOG
echo "--------------------------------------------------" >> $BOOT_LOG
ls -la /cassandra_data/data >> $BOOT_LOG
echo "--------------------------------------------------" >> $BOOT_LOG

cassandra -f | tee -a $BOOT_LOG
