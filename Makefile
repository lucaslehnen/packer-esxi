local:
	sudo PACKER_LOG=1 packer build --only=vmware-iso.esxi .

build:	
	ssh $(server) 'sudo rm -Rf /tmp/packer && mkdir /tmp/packer'
	scp -r $$(pwd)/* $(server):/tmp/packer
	ssh $(server) sudo packer init /tmp/packer
	ssh -t $(server) -t "cd /tmp/packer/ && sudo PACKER_LOG=1 packer build --only=vmware-iso.esxi ."