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

data "http" "my_ip" {
  url = "http://ipv4.icanhazip.com"
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
    DEBIAN_FRONTEND=noninteractive apt install --yes docker.io docker-compose
    curl -o docker-compose.yml https://raw.githubusercontent.com/EHER/deployment/main/docker-compose.yml
    curl -o .env https://raw.githubusercontent.com/EHER/deployment/main/.env.dist
    docker-compose up -d
    EOF
}

resource "digitalocean_firewall" "default" {
  name    = "docker-droplet-firewall"
  droplet_ids = [digitalocean_droplet.docker_droplet.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = [chomp(data.http.my_ip.response_body)]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "25"
    source_addresses = ["0.0.0.0/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "81"
    source_addresses = [chomp(data.http.my_ip.response_body)]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "465"
    source_addresses = ["0.0.0.0/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "587"
    source_addresses = ["0.0.0.0/0"]
  }

  outbound_rule {
    protocol = "tcp"
    port_range = "1-65535"
    destination_addresses = ["0.0.0.0/0"]
  }

  outbound_rule {
    protocol = "udp"
    port_range = "1-65535"
    destination_addresses = ["0.0.0.0/0"]
  }
}
