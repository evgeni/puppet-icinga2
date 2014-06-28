# == Class: icinga2::nrpe
#
# Install and configure an NRPE server.
#
# === Parameters
#
# None
#
# === Examples
#
#  class { icinga2::nrpe:
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
class icinga2::nrpe {
  include icinga2::nrpe::package
  include icinga2::nrpe::config
  include icinga2::nrpe::service
}
