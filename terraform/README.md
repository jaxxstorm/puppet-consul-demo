# Terraform Config

You can launch all the required infrastructure to test out the demo in digital ocean using this terraform config

## tfvars file

You'll need to generate a digital ocean API key from here: https://cloud.digitalocean.com/settings/api/tokens

Once you have an API key, add an SSH key: https://cloud.digitalocean.com/settings/security

Once done, create a `tfvars` file like so:

```
digital_ocean_token = "<enter your api key here>"
digital_ocean_domain = "terraform.example"
ssh_public_key = "ssh-rsa ......."
```
