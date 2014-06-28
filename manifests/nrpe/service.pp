# == Class: icinga2::nrpe::service
#
# Installs the icinga2 package.
#
# === Authors
#
# Evgeni Golov <evgeni@golov.de>
#
# === Copyright
#
# Copyright 2014 Evgeni Golov, unless otherwise noted.
#
class icinga2::nrpe::service (
  $ensure_running = hiera('ensure_running', $icinga2::params::ensure_running),
  $ensure_enable  = hiera('ensure_enable', $icinga2::params::ensure_enable),
) inherits icinga2::params {

  service { $icinga2::params::nrpe_service:
    ensure     => $ensure_running,
    enable     => $ensure_enable,
    hasrestart => true,
    restart    => "service ${icinga2::params::nrpe_service} reload",
    hasstatus  => true,
    require    => Class['icinga2::nrpe::config'],
  }

}
