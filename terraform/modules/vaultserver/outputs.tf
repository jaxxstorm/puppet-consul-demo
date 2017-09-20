output "addresses" {
  value = ["${digitalocean_droplet.vaultserver.*.ipv4_address}"]
}

output "ids" {
  value = ["${digitalocean_droplet.vaultserver.*.id}"]
}

output "names" {
  value = ["${digitalocean_droplet.vaultserver.*.name}"]
}
