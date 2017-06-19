
data "template_file" "mysql_user_data" {
  template = "${file("${path.module}/templates/mysql.tpl")}"
  count = "${var.count}"
  vars {
    hostname = "mysql-${count.index}"
    domain = "${var.digitalocean_domain}"
    fqdn = "mysql-${count.index}.${var.digitalocean_domain}"
  }
}

resource "digitalocean_droplet" "mysql" {
  count = "${var.count}"
  image = "centos-7-x64"
  name  = "mysql-${count.index}"
  region = "${var.digitalocean_region}"
  size = "${var.digitalocean_droplet_size}"
  private_networking = true
  ssh_keys = [ "${var.digitalocean_keys}" ]
  user_data = "${element(data.template_file.mysql_user_data.*.rendered,count.index)}"
}

resource "digitalocean_record" "mysql" {
  count  = "${var.count}"
  domain = "${var.digitalocean_domain}"
  type   = "A"
  name   = "mysql-${count.index}"
  value  = "${element(digitalocean_droplet.mysql.*.ipv4_address_private, count.index)}"
}

