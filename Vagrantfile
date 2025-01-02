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
