output "addresses" {
  value = ["${digitalocean_droplet.mysql.*.ipv4_address}"]
}

output "ids" {
  value = ["${digitalocean_droplet.mysql.*.id}"]
}

output "names" {
  value = ["${digitalocean_droplet.mysql.*.name}"]
}
