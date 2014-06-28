# == Class: icinga2::nrpe::config
#
# Configure the NRPE server.
#
# === Parameters
#
# [*ensure*]
#   Should the config files be installed? Defaults to "present".
#
# [*allowed_hosts*]
#   Which machines should be allowed to access our NRPE server.
#
# === Examples
#
#  class { icinga2::nrpe::config:
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
class icinga2::nrpe::config (
  $allowed_hosts = hiera('icinga2::nrpe::allowed_hosts', $icinga2::params::allowed_hosts),
  $ensure = hiera('ensure', $icinga2::params::ensure)
) inherits icinga2::params {

  $allowed_hosts_string = join($allowed_hosts, ',')

  file { '/etc/nagios/':
    ensure  => directory,
    mode    => '0644',
    require => Package['nrpe-server'],
  }

  augeas { 'nrpe.cfg_allowed_hosts':
    context => '/files/etc/nagios/nrpe.cfg',
    changes => [
      "set allowed_hosts ${allowed_hosts_string}",
    ],
    notify  => Service[$icinga2::params::nrpe_service],
    require => File['/etc/nagios/'],
  }

  file { $icinga2::params::nrpe_d_folder:
    ensure  => directory,
    mode    => '0644',
    recurse => true,
    source  => 'puppet:///modules/icinga2/etc/nagios/nrpe.d/',
    notify  => Service[$icinga2::params::nrpe_service],
    require => File['/etc/nagios/'],
  }

  file { '/etc/sudoers.d/':
    ensure  => directory,
    mode    => '0644',
  }

  file { '/etc/sudoers.d/icinga2':
    ensure  => $ensure,
    source  => 'puppet:///modules/icinga2/etc/sudoers.d/icinga2',
    notify  => Service[$icinga2::params::nrpe_service],
    require => File['/etc/sudoers.d/'],
  }

}
