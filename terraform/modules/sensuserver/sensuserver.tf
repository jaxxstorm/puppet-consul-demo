
data "template_file" "sensuserver_user_data" {
  template = "${file("${path.module}/templates/sensuserver.tpl")}"
  count = "${var.count}"
  vars {
    hostname = "sensuserver-${count.index}"
    domain = "${var.digitalocean_domain}"
    fqdn = "sensuserver-${count.index}.${var.digitalocean_domain}"
  }
}

resource "digitalocean_droplet" "sensuserver" {
  count = "${var.count}"
  image = "centos-7-x64"
  name  = "sensuserver-${count.index}"
  region = "${var.digitalocean_region}"
  size = "${var.digitalocean_droplet_size}"
  private_networking = true
  ssh_keys = [ "${var.digitalocean_keys}" ]
  user_data = "${element(data.template_file.sensuserver_user_data.*.rendered,count.index)}"
}

resource "digitalocean_record" "sensuserver" {
  count  = "${var.count}"
  domain = "${var.digitalocean_domain}"
  type   = "A"
  name   = "sensuserver-${count.index}"
  value  = "${element(digitalocean_droplet.sensuserver.*.ipv4_address_private, count.index)}"
}

