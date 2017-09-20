data "template_file" "vaultserver_user_data" {
  template = "${file("${path.module}/templates/vaultserver.tpl")}"
  count    = "${var.count}"

  vars {
    hostname = "vaultserver-${count.index}"
    domain   = "${var.digitalocean_domain}"
    fqdn     = "vaultserver-${count.index}.${var.digitalocean_domain}"
  }
}

resource "digitalocean_droplet" "vaultserver" {
  count              = "${var.count}"
  image              = "centos-7-x64"
  name               = "vaultserver-${count.index}"
  region             = "${var.digitalocean_region}"
  size               = "${var.digitalocean_droplet_size}"
  private_networking = true
  ssh_keys           = ["${var.digitalocean_keys}"]
  user_data          = "${element(data.template_file.vaultserver_user_data.*.rendered,count.index)}"
}

resource "digitalocean_record" "vaultserver" {
  count  = "${var.count}"
  domain = "${var.digitalocean_domain}"
  type   = "A"
  name   = "vaultserver-${count.index}"
  value  = "${element(digitalocean_droplet.vaultserver.*.ipv4_address_private, count.index)}"
}
