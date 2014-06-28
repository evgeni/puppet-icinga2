# == Class: icinga2::nrpe::package
#
# Install the NRPE server.
#
# === Parameters
#
# [*ensure*]
#   Should the NRPE server be installed? Defaults to "present".
#
# === Examples
#
#  class { icinga2::nrpe::package:
#  }
#
# === Authors
#
# Evgeni Golov <evgeni@golov.de>
#
# === Copyright
#
# Copyright 2014 Evgeni Golov, unless otherwise noted.
#
class icinga2::nrpe::package (
  $ensure = hiera('ensure', $icinga2::params::ensure),
) inherits icinga2::params {

  package { $icinga2::params::nrpe_server_package:
    ensure  => $ensure,
    alias   => 'nrpe-server',
  }

  package { $icinga2::params::plugins_packages:
    ensure  => $ensure,
  }

}

