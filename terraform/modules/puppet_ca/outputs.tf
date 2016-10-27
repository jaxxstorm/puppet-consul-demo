output "addresses" {
  value = ["${digitalocean_droplet.puppet_ca.*.ipv4_address}"]
}

output "id" {
  value = ["${digitalocean_droplet.puppet_ca.*.id}"]
}

output "name" {
  value = ["${digitalocean_droplet.puppet_ca.*.name}"]
}
