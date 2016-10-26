# A set of packages that don't need configuration
class profiles::stdpackages {

  package { 'unzip':
    ensure => present,
  }

  package { 'nagios-plugins-http':
    ensure => present,
  }

  package { 'bind-utils':
    ensure => present,
  }

}
