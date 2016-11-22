# Terraform Config

You can launch all the required infrastructure to test out the demo in digital ocean using this terraform config

## tfvars file

You'll need to generate a digital ocean API key from here: https://cloud.digitalocean.com/settings/api/tokens

Once you have an API key, create an SSH keypair on your machine if you don't already have one.

Once done, create a `me.tfvars` file like so:

```
digital_ocean_token = "<enter your api key here>"
digital_ocean_domain = "terraform.example"
ssh_public_key = "ssh-rsa ......." (ssh public key)
```

Next, "get" the modules. This moves the modules to `.terraform` within this dir:

```
terraform get
```

Finally, run the config, and specify how many puppetservers you want:

```
terraform apply -var-file=me.tfvars -var 'number_of_puppetservers=2'
```


