packer {
  required_plugins {
    qemu = {
      version = ">= 1.0.1"
      source  = "github.com/hashicorp/qemu"
    }    
    vmware = {
      version = ">= 1.0.3"
      source = "github.com/hashicorp/vmware"
    }
  }
}

source "vmware-iso" "esxi"{
  iso_url           = "${var.pkr_iso_url}"
  iso_checksum      = "${var.pkr_iso_checksum}"

  output_directory  = "build"  
  
  disk_size         = 20000
  disk_adapter_type = "ide"
  disk_type_id      = 0   
    
  network_adapter_type = "e1000e"  

  guest_os_type     = "vmkernel7"

  vm_name           = "${var.pkr_output_disk}"
  cpus              = "${var.pkr_cpu}"
  memory            = "${var.pkr_mem}"

  vmdk_name         = "${var.pkr_output_disk}_disk"  

  ssh_username      = "${var.pkr_ssh_user}"
  ssh_password      = "${var.pkr_ssh_pass}"
  ssh_timeout       = "15m"

  headless          = true  

  http_content      = {
      "/ks" = templatefile("${path.root}/ks.cfg", {})
  }

  vnc_bind_address  = "0.0.0.0"
  vnc_port_min      = "5900"
  vnc_port_max      = "5900"  

  boot_wait         = "2s"
  boot_command      = [
    "<enter><wait2><leftShiftOn>O<leftShiftOff><wait30>",
    " ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks ",//norts=1 ",
    # "nameserver=${var.pkr_nameserver} ip=${var.pkr_ip} netmask=${var.pkr_netmask} gateway=${var.pkr_gateway}",
    "<enter><wait>"
  ]
}

source "qemu" "esxi" {
  iso_url           = "${var.pkr_iso_url}"
  iso_checksum      = "${var.pkr_iso_checksum}"

  output_directory  = "build"
  shutdown_command  = "esxcli system shutdown poweroff -r \"packer finished\""
  
  disk_size         = "20G"
  disk_interface    = "ide"

  format            = "qcow2"  

  machine_type      = "q35"
  accelerator       = "kvm"
  headless          = true
  display           = "none"

  http_content      = {
      "/ks" = templatefile("${path.root}/ks.cfg", {})
  }
  
  qemuargs          = [        
    ["-cpu", "host,migratable=on,kvm=off"],  
    ["-machine", "pc-q35-5.2,accel=kvm,usb=off,dump-guest-core=off"],
    ["-global", "ICH9-LPC.disable_s3=1"], # desabilita secury boot
    ["-global", "ICH9-LPC.disable_s4=1"], # desabilita secury boot    
  ]

  vm_name           = "${var.pkr_output_disk}"
  cpus              = "${var.pkr_cpu}"
  memory            = "${var.pkr_mem}"

  net_device        = "e1000e"
  net_bridge        = "${var.pkr_net_bridge}"

  vnc_bind_address  = "0.0.0.0"
  
  ssh_username      = "${var.pkr_ssh_user}"
  ssh_password      = "${var.pkr_ssh_pass}"
  ssh_timeout       = "20m" 

  boot_wait         = "2s"
  boot_command      = [
    "<enter><wait2><leftShiftOn>O<leftShiftOff><wait5>",
    " ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks norts=1 ",
    "nameserver=${var.pkr_nameserver} ip=${var.pkr_ip} netmask=${var.pkr_netmask} gateway=${var.pkr_gateway}",
    "<enter><wait>"
  ]
}

build {
  sources = ["source.qemu.esxi", "source.vmware-iso.esxi"]
}
