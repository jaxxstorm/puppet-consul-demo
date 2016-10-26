output "addresses" {
  value = ["${digitalocean_droplet.puppetserver.*.ipv4_address}"]
}

output "ids" {
	value = ["${digitalocean_droplet.puppetserver.*.id}"]
}

output "names" {
	value = ["${digitalocean_droplet.puppetserver.*.name}"]
}
