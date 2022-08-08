#!/bin/bash
set -x

SCRIPTDIR=$(dirname $(realpath "${BASH_SOURCE[0]}"))

quay_user=alam-cran

#Install skopeo
sudo dnf makecache --refresh
sudo dnf -y install skopeo



#Copy docker registry container to quay
podman login -u="alam_cran" -p="WVFND9mreDjDbZhZsdxDEy3X8nGur/aNYsLFeVBgc9T7msooZqbAU1m8IExDHkBV" quay.io
skopeo copy docker://docker.io/library/registry:2 docker://quay.io/${quay_user}/registry:2

#Use Skopeo to get the digest of the container
sha=$(skopeo inspect docker://quay.io/${quay_user}/registry:2 --format "{{ .Digest }}")
echo $sha

#use a MachineConfig Custom Resource to make sure registry comes up when the masters boot
cat <<EOF >> $SCRIPTDIR/machine_config.yaml
apiVersion: machineconfiguration.openshift.io/v1
kind: MachineConfig
metadata:
  labels:
    machineconfiguration.openshift.io/role: master
  name: 99-master-local-registry
spec:
  config:
    ignition:
      config: {}
      security:
        tls: {}
      timeouts: {}
      version: 3.1.0
    networkd: {}
    passwd: {}
    systemd:
      units:
        - name: container-registry.service
          enabled: true
          contents: |
            [Unit]
            Description=Local OpenShift Container Registry
            Wants=network.target
            After=network-online.target
            [Service]
            Environment=PODMAN_SYSTEMD_UNIT=%n
            Restart=on-failure
            TimeoutStopSec=70
            ExecStartPre=/usr/bin/mkdir -p /var/local-registry
            ExecStartPre=/bin/rm -f %t/container-registry.pid %t/container-registry.ctr-id
            ExecStart=/usr/bin/podman run --conmon-pidfile %t/container-registry.pid --cidfile %t/container-registry.ctr-id --cgroups=no-conmon --replace -d --net=host --name registry -v /var/local-registry:/var/lib/registry:z quay.io/$quay_user/registry@$sha
            ExecStop=/usr/bin/podman stop --ignore --cidfile %t/container-registry.ctr-id -t 10
            ExecStopPost=/usr/bin/podman rm --ignore -f --cidfile %t/container-registry.ctr-id
            PIDFile=%t/container-registry.pid
            Type=forking
            [Install]
            WantedBy=multi-user.target default.target
EOF

oc apply -f $SCRIPTDIR/machine_config.yaml

#The Machine Config Operator will apply this configuration to each node and gracefully reboot them one at a time. You can monitor this process:
#
#$ watch oc get nodes
#
#NAME                           STATUS                       ROLES           AGE   VERSION
#<node1>                        Ready                        master,worker   44h   v1.22.0-rc.0+75ee307
#<node2>                        Ready                        master,worker   44h   v1.22.0-rc.0+75ee307
#<node3>                        NotReady,SchedulingDisabled  master,worker   44h   v1.22.0-rc.0+75ee307
#After a while, you can check that the service is running on each node:
#
#$ oc debug node/<node-name>
#sh-4.4# chroot /host
#sh-4.4# systemctl is-active container-registry
#active

 