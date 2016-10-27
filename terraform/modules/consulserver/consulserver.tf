
data "template_file" "consulserver_user_data" {
  template = "${file("${path.module}/templates/consulserver.tpl")}"
  count = "${var.count}"
  vars {
    hostname = "consulserver-${count.index}"
    domain = "${var.digitalocean_domain}"
    fqdn = "consulserver-${count.index}.${var.digitalocean_domain}"
  }
}

resource "digitalocean_droplet" "consulserver" {
  count = "${var.count}"
  image = "centos-7-x64"
  name  = "consulserver-${count.index}"
  region = "${var.digitalocean_region}"
  size = "${var.digitalocean_droplet_size}"
  private_networking = true
  ssh_keys = [ "${var.digitalocean_keys}" ]
  user_data = "${element(data.template_file.consulserver_user_data.*.rendered,count.index)}"
}

resource "digitalocean_record" "consulserver" {
  count  = "${var.count}"
  domain = "${var.digitalocean_domain}"
  type   = "A"
  name   = "consulserver-${count.index}"
  value  = "${element(digitalocean_droplet.consulserver.*.ipv4_address_private, count.index)}"
}

