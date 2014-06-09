class icinga2::package(
  $ensure = hiera('ensure', $icinga2::params::ensure),
  ) inherits icinga2::params {

  apt::source { 'packages_icinga_org':
    location   => 'http://packages.icinga.org/debian',
    release    => 'icinga-wheezy',
    repos      => 'main',
    key        => 'C6E319C334410682',
    key_source => 'http://packages.icinga.org/icinga.key',
  }

  package { $icinga2::params::icinga2_package:
    ensure  => $ensure,
    alias   => 'icinga2',
    require => Apt::Source['packages_icinga_org'],
  }

  package { $icinga2::params::nrpe_plugin_package:
    ensure  => $ensure,
    alias   => 'nrpe-plugin',
  }

  if $icinga2::frontend_package {
    package { $icinga2::frontend_package:
      ensure  => $ensure,
      alias   => 'icinga2-frontend',
      require => Apt::Source['packages_icinga_org'],
    }
  }

}
