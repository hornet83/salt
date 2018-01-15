include:
   - common

get repos:
   cmd.run:
      - name: |
         host download.docker.com
         yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
         yum-config-manager --enable docker-ce-edge
         yum-config-manager --enable docker-ce-test
         cat <<EOF > /etc/yum.repos.d/kubernetes.repo
         [kubernetes]
         name=Kubernetes
         baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
         enabled=1
         gpgcheck=1
         repo_gpgcheck=1
         gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
                 https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
         EOF
         setenforce 0

install required rpms:
   pkg.installed:
     - pkgs:
       - kubernetes
       - flannel
       - docker-logrotate
       - etcd

/etc/kubernetes/config:
   file.managed:
     - user: root
     - group: root
     - mode: 644
     - contents: |
         KUBE_LOGTOSTDERR="--logtostderr=true"
         KUBE_LOG_LEVEL="--v=0"
         KUBE_ALLOW_PRIV="--allow-privileged=false"
         KUBE_MASTER="--master=http://kubemaster:8080"

/etc/sysconfig/flanneld:
   file.managed:
     - user: root
     - group: root
     - mode: 644
     - contents: |
         FLANNEL_ETCD_ENDPOINTS="http://kubemaster:2379"
         FLANNEL_ETCD_PREFIX="/kube-centos/network"

{% if 'master' in grains["id"] %}
/etc/etcd/etcd.conf:
   file.managed:
     - user: root
     - group: root
     - mode: 644
     - contents: |
         # [member]
         ETCD_NAME=default
         ETCD_DATA_DIR="/var/lib/etcd/default.etcd"
         ETCD_LISTEN_CLIENT_URLS="http://0.0.0.0:2379"
         ETCD_ADVERTISE_CLIENT_URLS="http://0.0.0.0:2379"

configure etcd:
   cmd.run:
      - name: |
         systemctl start etcd
         etcdctl mkdir /kube-centos/network
         etcdctl mk /kube-centos/network/config "{ \"Network\": \"10.200.0.0/16\", \"SubnetLen\": 24, \"Backend\": { \"Type\": \"vxlan\" } }"

/etc/kubernetes/apiserver:
   file.managed:
     - user: root
     - group: root
     - mode: 644
     - contents: |
         KUBE_API_ADDRESS="--address=0.0.0.0"
         KUBE_API_PORT="--port=8080"
         KUBELET_PORT="--kubelet-port=10250"
         KUBE_ETCD_SERVERS="--etcd-servers=http://kubemaster:2379"
         KUBE_SERVICE_ADDRESSES="--service-cluster-ip-range=10.200.0.0/16"
         KUBE_API_ARGS=""

{% for service in ['etcd', 'kube-apiserver', 'kube-controller-manager', 'kube-scheduler', 'flanneld'] %}
start-service {{ service }}:
   service.running:
      - name: {{ service }}.service
      - enable: True
{% endfor %}
{% endif %}

{% if 'worker' in grains["id"] %}
/etc/kubernetes/kubelet:
   file.managed:
     - user: root
     - group: root
     - mode: 644
     - contents: |
         KUBELET_ADDRESS="--address=0.0.0.0"
         KUBELET_PORT="--port=10250"
         KUBELET_HOSTNAME="--hostname-override={{ grains['host'] }}"
         KUBELET_API_SERVER="--api-servers=http://kubemaster:8080"
         KUBELET_ARGS=""
        
{% for service in ['kube-proxy', 'kubelet', 'flanneld', 'docker'] %}
start-service {{ service }}:
   service.running:
      - name: {{ service }}.service
      - enable: True
{% endfor %} 

configure kubectl:
   cmd.run:
      - name: |
         kubectl config set-cluster default-cluster --server=http://kubemaster:8080
         kubectl config set-context default-context --cluster-default-cluster --user=default-admin
         kubectl config use-context default-context
{% endif %}

kube/deploy/completed:
   event.send:
     - name: kube/deploy/completed
