packer {
  required_plugins {
    vagrant = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/vagrant"
    }
    qemu = {
      version = ">= 1.1.0"
      source  = "github.com/hashicorp/qemu"
    }
  }
}

variable "version" {
  type    = string
  default = "unknown"
}

variable "vm_name" {
  default = "fortisiem"
}

variable "iso_url" {
  default = "/var/lib/libvirt/images/FortiSIEM.qcow2"
}

variable "iso_checksum" {
  default = "none"
}

variable "qemu_binary" {
  default = "qemu-system-x86_64"
}

variable "qemu_dir" {
  default = "/usr/bin"
}

variable "qemu_ssh_port" {
  default = 52222
}

variable "password" {
  default = "ProspectHills"
}

variable "new_password" {
  default = "SupersecretPa$$w0rd"
}

source "qemu" "fortisiem" {
  vm_name = "fortisiem-${var.version}"
  iso_url = var.iso_url
  iso_checksum = var.iso_checksum
  disk_image = true
  format = "qcow2"
  output_directory = "tmp_out"
  accelerator = "kvm"
  cpus = 8
  memory = "32768"
  headless = true
  qemu_binary = var.qemu_binary
  boot_wait = "1m"
  communicator = "none"

  boot_command = [
    "root<enter>",
    "<wait10>",
    "${var.password}<enter>",
    "<wait10>",
    "${var.password}<enter>",
    "<wait10>",
    "${var.new_password}<enter>",
    "<wait10>",
    "${var.new_password}<enter>",
    "<wait10>",
    "useradd -m -s /bin/bash vagrant<enter>",
    "<wait10>",
    "echo \"vagrant:vagrant\" | chpasswd<enter>",
    "<wait10>",
    "echo \"vagrant ALL=(ALL) NOPASSWD:ALL\" >> /etc/sudoers.d/vagrant<enter>",
    "<wait10>",
    "shutdown now<enter>"
  ]
}

build {
  name = "fortisiem"

  sources = [
    "qemu.fortisiem"
  ]

  post-processor "vagrant" {
    output = "builds/fortinet-fortisiem-${var.version}.box"
  }
}