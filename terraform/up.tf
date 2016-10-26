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

module "puppet_ca" {
  source = "modules/puppet_ca"
  digitalocean_domain = "${var.digital_ocean_domain}"
  digitalocean_keys = "${digitalocean_ssh_key.personal.id}"
}

