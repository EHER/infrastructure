terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }

  required_version = ">= 0.13"
}

provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_ssh_key" "default" {
  name       = "default"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "digitalocean_droplet" "docker_droplet" {
  image      = "ubuntu-24-10-x64"
  name       = "docker-droplet"
  region     = var.region
  size       = "s-1vcpu-1gb"
  monitoring = true
  tags       = ["docker-instance"]
  ssh_keys   = [digitalocean_ssh_key.default.id]
  user_data  = <<-EOF
    #!/bin/bash
    apt update
    apt install --yes docker.io
    EOF
}
