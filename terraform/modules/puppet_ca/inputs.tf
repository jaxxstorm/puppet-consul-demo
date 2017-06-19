# Token
variable "digitalocean_domain" {}
variable "digitalocean_keys" { }
variable "digitalocean_region" { default = "lon1" }
variable "digitalocean_droplet_size" { default = "2gb" }
variable "count" { default=1 }
