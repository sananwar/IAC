terraform {
  required_providers {
    esxi = {
      source = "registry.terraform.io/josenk/esxi"
    }
  }
}

provider "esxi" {
  esxi_hostname = "192.168.1.20"
  esxi_hostport = "22"
  esxi_hostssl  = "443"
  esxi_username = "root"
  esxi_password = "Welkom01!"
}

resource "esxi_guest" "webserver" {
  guest_name   = "webserver"
  disk_store   = "datastore1"
  numvcpus     = 1
  memsize      = 1024
  ovf_source   = "https://cloud-images.ubuntu.com/releases/24.04/release/ubuntu-24.04-server-cloudimg-amd64.ova"

  network_interfaces {
    virtual_network = "VM Network"
  }

  guestinfo = {
    "metadata"          = filebase64("metadata.yaml")
    "metadata.encoding" = "base64"
    "userdata"          = filebase64("webserver_userdata.yaml")
    "userdata.encoding" = "base64"
  }
}

resource "esxi_guest" "databaseserver" {
  guest_name   = "databaseserver"
  disk_store   = "datastore1"
  numvcpus     = 1
  memsize      = 1024
  ovf_source   = "https://cloud-images.ubuntu.com/releases/24.04/release/ubuntu-24.04-server-cloudimg-amd64.ova"

  network_interfaces {
    virtual_network = "VM Network"
  }

  guestinfo = {
    "metadata"          = filebase64("metadata.yaml")
    "metadata.encoding" = "base64"
    "userdata"          = filebase64("databaseserver_userdata.yaml")
    "userdata.encoding" = "base64"
  }
}

output "webserver_ip" {
  value = esxi_guest.webserver.ip_address
}

output "databaseserver_ip" {
  value = esxi_guest.databaseserver.ip_address
}
