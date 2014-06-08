# == Class: icinga2::service
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
class icinga2::service inherits icinga2 {

  service { 'icinga2':
    ensure     => $icinga2::ensure_running,
    enable     => $icinga2::ensure_enable,
    hasrestart => true,
    restart    => 'service icinga2 reload',
    hasstatus  => true,
    require    => Package['icinga2'],
  }

}

