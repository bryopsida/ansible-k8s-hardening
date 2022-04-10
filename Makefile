inventory ?= github-single-kubeadm.yml
PYTHON_VERSION ?= `python3 -c 'import platform; print(".".join(platform.python_version_tuple()[0:2]))'`
EXTRA_ARGS ?= 

install-plugins:
	ansible-galaxy collection install community.general
	ansible-galaxy install stackhpc.libvirt-vm
	ansible-galaxy install stackhpc.libvirt-host
	ansible-galaxy collection install community.libvirt
	ansible-galaxy collection install ansible.posix
	ansible-galaxy collection install community.kubernetes
	ansible-galaxy collection install kubernetes.core
	ansible-galaxy collection install ansible.utils
	ansible-galaxy collection install community.crypto
	pip3 install stormssh
lint:
	pip3 install "ansible-lint"
	ansible-lint playbooks/*.yml
hostname-check:
	ansible-playbook -i inventory/$(inventory) playbooks/get-hostname.yml $(EXTRA_ARGS)
vm-management-framework:
	ansible-playbook -i inventory/$(inventory) playbooks/vm-management-framework.yml $(EXTRA_ARGS)
nodes:
	ansible-playbook -i inventory/$(inventory) playbooks/create-cluster-nodes.yml $(EXTRA_ARGS)
cluster:
	ansible-playbook -i inventory/$(inventory) playbooks/provision-cluster.yml $(EXTRA_ARGS)
install-kube-bench:
	ansible-playbook -i inventory/$(inventory) playbooks/install-kube-bench.yml $(EXTRA_ARGS)
fix-kube-bench-fails:
	ansible-playbook -i inventory/$(inventory) playbooks/fix-kube-bench-fails.yml $(EXTRA_ARGS)
evaluate-kube-bench:
	ansible-playbook -i inventory/$(inventory) playbooks/evaluate-kube-bench.yml $(EXTRA_ARGS)
cis-compliant: install-kube-bench fix-kube-bench-fails evaluate-kube-bench
falco:
	ansible-playbook -i inventory/$(inventory) playbooks/install-falco.yml $(EXTRA_ARGS)
gvisor:
	ansible-playbook -i inventory/$(inventory) playbooks/install-gvisor.yml $(EXTRA_ARGS)