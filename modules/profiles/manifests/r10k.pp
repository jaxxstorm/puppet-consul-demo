# install r10k and add a cron job
class profiles::r10k {

  cron {'r10k_deploy_environment':
  	ensure  => present,
    command => 'r10k deploy environment -p -c /etc/puppetlabs/r10k.yaml  --verbose > /var/log/puppetlabs/r10k_deploy_environments.out',
    user    => 'root',
    hour    => '*',
    minute  => "*/5",
    environment => 'MAILTO=""',
  }

}
