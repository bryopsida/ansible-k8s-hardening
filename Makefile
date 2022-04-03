inventory ?= github-ci.yml

lint:
	pip3 install "ansible-lint"
	ansible-lint playbooks/*.yml roles/*.yml
hostname-check:
	ansible-playbook -i inventory/$(inventory) playbooks/get-hostname.yml
local-test-target:
	multipass launch --cpus 2 --mem 8G --disk 32G --name ansible 20.04
stop-local:
	multipass stop ansible
start-local:
	multipass start ansible