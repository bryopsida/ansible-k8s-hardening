inventory ?= github-single-kubeadm.yml

install-plugins:
	ansible-galaxy collection install community.general
	ansible-galaxy install stackhpc.libvirt-vm
	ansible-galaxy install stackhpc.libvirt-host
	ansible-galaxy collection install community.libvirt
	ansible-galaxy collection install ansible.posix
lint:
	pip3 install "ansible-lint"
	ansible-lint playbooks/*.yml
hostname-check:
	ansible-playbook -i inventory/$(inventory) playbooks/get-hostname.yml
cluster:
	ansible-playbook -i inventory/$(inventory) playbooks/provision-cluster.yml
cis-compliant:
	ansible-playbook -i inventory/$(inventory) playbooks/install-kube-bench.yml
	ansible-playbook -i inventory/$(inventory) playbooks/evaluate-kube-bench.yml
local-test-target:
	multipass launch --cpus 2 --mem 8G --disk 32G --name ansible 20.04
stop-local:
	multipass stop ansible
start-local:
	multipass start ansible