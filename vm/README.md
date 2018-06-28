# kitpress VM setup

Contents of this folder are used to create a prefab kitpress-dev VM. The VM will be set up to mimic an AWS EC2 instance, using the Amazon Linux 2 VirtualBox image.

Note that no additional libraries will be installed (apache, PHP, etc); we're only here to get the same baseline as EC2, from which we can run unified scripts/tools to manage machine configuration.

## Prerequisites

VirtualBox

## Building the VM

`make install` will:

* Download the .vdi HDD image if it's not present in /canonical (be aware this is ~1.4GB)
* Make copies of the .vbox and .vdi from /canonical into /build
* Construct and attach the seed ISO (see /ec2-seed) which sets up some first-boot settings
* Register the new VM with VirtualBox as kitpress-dev

## Networking

The VM is created with two network adapters: eth0 is attached to NAT for internet connectivity, while eth1 is attached to the host-only network for comms with the host machine. eth1 is set up for a static IP of 192.168.56.10; these network settings can be changed in `ec2-seed/meta-data`.

## User accounts

Only one user account is created, for `ec2-user`. This user is set up to only allow SSH via authorized_keys, using the keypair in /key. Ex: `ssh ec2-user@192.168.56.10 -i /path/to/id_rsa_kitpress`

Additional accounts can be configured by editing `ec2-seed/user-data`.

## Tearing down the VM

After shutting down the VM, simply run `make uninstall`. This will unregister the VM with VirtualBox and remove the /build folder.