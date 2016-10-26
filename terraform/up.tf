# token
variable "digital_ocean_token" {}
variable "digital_ocean_domain" {}
variable "ssh_public_key" {}

provider "digitalocean" {
  token = "${var.digital_ocean_token}"
}

resource "digitalocean_ssh_key" "personal" {
  name = "personal_key"
  public_key = "${var.ssh_public_key}"
}

resource "digitalocean_domain" "default" {
  name = "${var.digital_ocean_domain}"
  ip_address = "127.0.0.1"
}

module "puppet_ca" {
  source = "modules/puppet_ca"
  digitalocean_domain = "${var.digital_ocean_domain}"
  digitalocean_keys = "${digitalocean_ssh_key.personal.id}"
}

module "puppetserver" {
  source = "modules/puppetserver"
  digitalocean_domain = "${var.digital_ocean_domain}"
  digitalocean_keys = "${digitalocean_ssh_key.personal.id}"
}
