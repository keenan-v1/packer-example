packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "debian" {
  region = "us-east-1"

  source_ami_filter {
    filters = {
      virtualization-type = "hvm"
      name                = "debian-11-amd64-*"
      root-device-type    = "ebs"
    }
    owners      = ["136693071363"]
    most_recent = true
  }

  instance_type  = "t2.small"
  ssh_username   = "admin"
  ssh_agent_auth = false

  ami_name    = "base-debian-11-amd64-${formatdate("YYYYMMDD-hhmmss", timestamp())}"
  ami_regions = ["us-east-1"]
}

build {
  sources = [
    "source.amazon-ebs.debian"
  ]

  provisioner "file" {
    source      = "./src"
    destination = "/tmp"
  }

  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; sudo {{ .Vars }} {{ .Path }}"
    script          = "image.sh"
  }
}


