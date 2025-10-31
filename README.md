# Vanilla Kubernetes (vanilla-k8s)

Automated multi-node Kubernetes cluster setup using Multipass, Ansible, cloud-init, and Netplan.  
Ideal for learning, homelab, testing, or local development.

---

## Features

- High-availability Kubernetes cluster (multiple master nodes + worker nodes)  
- Flexible number of masters and workers depending on available resources  
- HAProxy load balancer for the API server  
- Supports Calico, Flannel, or Cilium CNI plugins  
- Automated node provisioning with Multipass and cloud-init  
- Scripts to start, stop, restart, and delete nodes  
- Optional installation of Helm and Flux CLI for GitOps workflows  

---

## Prerequisites

- Ubuntu (tested on Ubuntu Server 22.04.5 LTS)  
- Multipass (tested on Multipass 1.16.1)  
  - Or you can use other VMs if you want to run only the Ansible playbooks (manual VM setup required)  
- Ansible (tested on Ansible Core 2.17.14)  
- Bash (or compatible shell)  
- Sufficient CPU, memory, and disk for all nodes  

---

## Quick Start

1. Clone the repository

```bash
git clone https://github.com/soft-titus/vanilla-k8s
cd vanilla-k8s
````

2. Generate an SSH key (if you don't have one)

```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/k8s.key -N ""
```

This will create:

* Private key: `~/.ssh/k8s.key`
* Public key: `~/.ssh/k8s.key.pub`

Optional: Configure SSH access for cluster nodes

* If you don't have an existing `~/.ssh/config`, you can copy the sample file:

```bash
cp .ssh/config ~/.ssh/config
chmod 600 ~/.ssh/config
```

* If you already have an SSH config file, append the sample contents to your existing file instead of overwriting it.
* This will make it easier to SSH into the Kubernetes nodes without specifying the private key and host manually.

3. Configure the cluster

```bash
cp cluster.env.example cluster.env
# Edit cluster.env to define nodes, SSH keys, network, and Kubernetes settings
# You can adjust the number of master and worker nodes based on your available resources
```

4. Generate Netplan configuration for the bridge network

```bash
bash netplan/generate-netplan-config.sh
```

This will create `netplan/99-k8s-bridge.yaml`, which you can apply on your host:

```bash
sudo cp netplan/99-k8s-bridge.yaml /etc/netplan/
sudo netplan apply
```

5. Copy and run the networkd-dispatcher script to disable bridge packet filtering

```bash
sudo cp networkd-dispatcher/routable.d/10-bridge-nf-fix.sh /etc/networkd-dispatcher/routable.d/
sudo chmod a+x /etc/networkd-dispatcher/routable.d/10-bridge-nf-fix.sh
sudo /etc/networkd-dispatcher/routable.d/10-bridge-nf-fix.sh
```

6. Launch VMs

```bash
bash multipass/launch-vms.sh
```

7. Generate Ansible inventory and variables

```bash
bash ansible/generate-ansible-inventory-and-vars.sh
```

8. Run the Ansible playbooks

```bash
ansible-playbook -i ansible/hosts.ini ansible/playbooks/main.yaml
```

9. Manage VMs

* Start nodes: `bash multipass/start-vms.sh`
* Stop nodes: `bash multipass/stop-vms.sh`
* Restart nodes: `bash multipass/restart-vms.sh`
* Delete nodes: `bash multipass/delete-vms.sh`

## Notes

* This setup does not include:

  * Ingress controllers
  * CSI drivers
  * Metrics server

* These components are intended to be installed and managed via GitOps using Flux, giving you full control over which add-ons to deploy.
