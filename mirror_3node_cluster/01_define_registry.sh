#!/bin/bash
set -x

SCRIPTDIR=$(dirname $(realpath "${BASH_SOURCE[0]}"))

node1=172.16.13.11
node2=172.16.13.12
node3=172.16.13.13
nodes="$node1 $node2 $node3"
quay_user=alam-cran
path_to_pull_secret=$SCRIPTDIR/pull-secret.txt


#To define these registries as insecure on your workstation, edit /etc/containers/registries.conf to set the following:
#
#[registries.insecure]
#registries = ['<node1>','<node2>', '<node3>']

cat <<EOF >> $SCRIPTDIR/insecure.yaml
apiVersion: config.openshift.io/v1
kind: Image
metadata:
  name: cluster
spec:
  registrySources:
    insecureRegistries:
    - localhost:5000
    - $node1:5000
    - $node2:5000
    - $node3:5000
EOF

oc apply -f $SCRIPTDIR/insecure.yaml

#Again you can use “oc get nodes” to follow the progress and check the applied configuration:
#
#$ oc debug node/<node>
#sh-4.4# chroot /host
#sh-4.4# cat /etc/containers/registries.conf
#...
#[[registry]]
#  prefix = ""
#  location = "localhost:5000"
#  insecure = true
#...