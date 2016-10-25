# Token
variable "ssh_public_key" { }
variable "digital_ocean_token" {}
variable "digital_ocean_domain" {}
variable "digitalocean_region" { default = "lon1" }
variable "digitalocean_droplet_size" { default = "1gb" }
variable "count" { default=3 }

provider "digitalocean" {
  token = "${var.digital_ocean_token}"
}

resource "digitalocean_ssh_key" "personal" {
  name = "personal_key"
  public_key = "${var.ssh_public_key}"
}

resource "digitalocean_droplet" "puppetmaster" {
  count = "${var.count}"
  image = "centos-7-x64"
  name  = "puppetmaster-${count.index}"
  region = "${var.digitalocean_region}"
  size = "${var.digitalocean_droplet_size}"
  private_networking = true
  ssh_keys = [ "${digitalocean_ssh_key.personal.id}" ]
}

resource "digitalocean_domain" "default" {
  name = "${var.digital_ocean_domain}"
  ip_address = "${digitalocean_droplet.puppetmaster.0.ipv4_address}"
}

resource "digitalocean_record" "puppetmaster" {
  count  = "${var.count}"
  domain = "${digitalocean_domain.default.name}"
  type   = "A"
  name   = "puppetmaster-${count.index}"
  value  = "${element(digitalocean_droplet.puppetmaster.*.ipv4_address_private, count.index)}"
}
