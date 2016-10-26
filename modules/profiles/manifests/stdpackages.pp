# A set of packages that don't need configuration
class profiles::stdpackages {

  package { 'unzip':
    ensure => present,
  }

}
