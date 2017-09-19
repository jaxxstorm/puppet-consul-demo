output "addresses" {
  value = ["${digitalocean_droplet.consulserver.*.ipv4_address}"]
}

output "ids" {
  value = ["${digitalocean_droplet.consulserver.*.id}"]
}

output "names" {
  value = ["${digitalocean_droplet.consulserver.*.name}"]
}
