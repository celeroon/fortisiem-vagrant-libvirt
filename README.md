# Fortinet FortiSIEM Vagrant Box

This repository contains a Packer template for creating a Fortinet FortiSIEM Vagrant Box for the libvirt provider.

### How to Create the Box

1. Install KVM. Information on how to set up KVM can be found online. This setup has been tested on Debian 11. Additionally, you need to install the following:
   - **git**
   - **packer** (tested on v1.11.2)
   - **vagrant** (tested on v2.2.14)

2. Verify the version of the `vagrant-libvirt` plugin. It must be **0.9.0**. To check the version, run:

   ```bash
   vagrant plugin list
   ```

   If `vagrant-libvirt` is not installed or has an older version, you can install or update it with:

   ```bash
   vagrant plugin install vagrant-libvirt --plugin-version 0.9.0
   ```

3. Install Packer plugins:

   ```bash
   packer plugins install github.com/hashicorp/qemu
   packer plugins install github.com/hashicorp/vagrant
   ```

4. Download the FortiSIEM archive using your licensed account. Unzip the archive, for example, in the `Downloads` directory. Rename the image to match the required format (the name must match exactly): **FortiSIEM.qcow2**.

5. Move the image to the appropriate directory and adjust its ownership and permissions:

   ```bash
   sudo cp ~/Downloads/FortiSIEM.qcow2 /var/lib/libvirt/images/FortiSIEM.qcow2
   sudo chown libvirt-qemu:kvm /var/lib/libvirt/images/FortiSIEM.qcow2
   sudo chmod 640 /var/lib/libvirt/images/FortiSIEM.qcow2
   ```

6. Clone this repository and navigate to its directory:

   ```bash
   git clone https://github.com/celeroon/fortisiem-vagrant-libvirt
   cd fortisiem-vagrant-libvirt
   ```

7. Use Packer to build the Vagrant Box for the specified version of FortiSIEM:

   ```bash
   packer build -var 'version=7.3.0' FortiSIEM.pkr.hcl
   ```

   If you encounter issues, run with debug logging enabled:

   ```bash
   PACKER_LOG=1 packer build -var 'version=7.3.0' FortiSIEM.pkr.hcl
   ```

8. Move the created Vagrant Box to the `/var/lib/libvirt/images` directory:

   ```bash
   sudo mv ./builds/fortinet-fortisiem-7.3.0.box /var/lib/libvirt/images
   ```

9. Move the metadata file to the `/var/lib/libvirt/images` directory:

   ```bash
   sudo mv ./src/FortiSIEM.json /var/lib/libvirt/images
   ```

10. Update the Vagrant Box metadata file with the correct path and version:

    ```bash
    fsm_version="7.3.0"
    sudo sed -i "s/\"version\": \"VER\"/\"version\": \"$fsm_version\"/; s#\"url\": \"file://HOME/boxes/fortinet-fortisiem-VER.box\"#\"url\": \"file:///var/lib/libvirt/images/fortinet-fortisiem-$fsm_version.box\"#" /var/lib/libvirt/images/FortiSIEM.json
    ```

11. Add the FortiSIEM Vagrant Box to the inventory:

    ```bash
    vagrant box add --box-version 7.3.0 /var/lib/libvirt/images/FortiSIEM.json
    ```

### Vagrantfile sample

```
Vagrant.configure("2") do |config|
  config.vm.define "fortisiem" do |fortisiem|
    fortisiem.vm.box = "fortinet-fortisiem"
    fortisiem.vm.provider :libvirt do |libvirt|
      libvirt.management_network_name = 'lab_lan'
      libvirt.management_network_address = '192.168.100.0/24'
      # libvirt.management_network_mac = '64:8b:23:b7:9a:39'
      libvirt.cpus = 8
      libvirt.memory = 32768
      libvirt.storage :file, :path => 'FortiSIEM-OPT.qcow2', :size => '100G', :bus => 'virtio', :type => 'qcow2', :discard => 'unmap', :detect_zeroes => 'on'
      libvirt.storage :file, :path => 'FortiSIEM-CMDB.qcow2', :size => '60G', :bus => 'virtio', :type => 'qcow2', :discard => 'unmap', :detect_zeroes => 'on'
      libvirt.storage :file, :path => 'FortiSIEM-SVN.qcow2', :size => '60G', :bus => 'virtio', :type => 'qcow2', :discard => 'unmap', :detect_zeroes => 'on'
      libvirt.storage :file, :path => 'FortiSIEM-LOCAL-EVENT-DB.qcow2', :size => '200G', :bus => 'virtio', :type => 'qcow2', :discard => 'unmap', :detect_zeroes => 'on'
    end
    fortisiem.ssh.insert_key = false
    fortisiem.nfs.verify_installed = false
    fortisiem.vm.synced_folder '.', '/vagrant', disabled: true
    fortisiem.ssh.username = "vagrant"
    fortisiem.ssh.password = "vagrant"
  end
end
```

### Acknowledgments

Special thanks to the following users for providing repositories with Packer examples for creating Vagrant Boxes:

- [https://github.com/mweisel](https://github.com/mweisel)
- [https://github.com/krjakbrjak](https://github.com/krjakbrjak)
