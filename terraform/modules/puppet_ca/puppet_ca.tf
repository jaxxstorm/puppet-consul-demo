data "template_file" "puppetca_user_data" {
  template = "${file("${path.module}/templates/puppet.tpl")}"
  count = "${var.count}"
  vars {
    hostname = "puppetserver-${count.index}"
    domain = "${var.digitalocean_domain}"
    fqdn   = "puppetserver-${count.index}.${var.digitalocean_domain}"
  }
}

resource "digitalocean_droplet" "puppet_ca" {
  count = "${var.count}"
  image = "centos-7-x64"
  name  = "puppetserver-${count.index}"
  region = "${var.digitalocean_region}"
  size = "${var.digitalocean_droplet_size}"
  private_networking = true
  ssh_keys = [ "${var.digitalocean_keys}" ]
  user_data = "${element(data.template_file.puppetca_user_data.*.rendered,count.index)}"
}

resource "digitalocean_record" "puppetca" {
  count  = "${var.count}"
  domain = "${var.digitalocean_domain}"
  type   = "A"
  name   = "puppetserver-${count.index}"
  value  = "${element(digitalocean_droplet.puppet_ca.*.ipv4_address_private, count.index)}"
}

