# == Class: icinga2::params
#
# Default parameters for the icinga class.
#
# === Authors
#
# Evgeni Golov <evgeni@golov.de>
#
# === Copyright
#
# Copyright 2014 Evgeni Golov, unless otherwise noted.
#
class icinga2::params {

  case $::osfamily {
    Debian: {
      $icinga2_package     = 'icinga2'
      $classicui_package   = 'icinga2-classicui'
      $web_package         = 'icinga-web'
      $frontend            = 'classicui'
      $frontend_users      = { icingaadmin => '$apr1$QjQi49DK$R2n42by8lpmaMP6D69gki1' }
      $backend             = 'pgsql'
      $ido_mysql_package   = 'icinga2-ido-mysql'
      $ido_pgsql_package   = 'icinga2-ido-pgsql'
      $ido_mysql_module    = 'ido-mysql'
      $ido_pgsql_module    = 'ido-pgsql'
      $nrpe_plugin_package = 'nagios-nrpe-plugin'
      $nrpe_server_package = 'nagios-nrpe-server'
      $nrpe_service        = 'nagios-nrpe-server'
      $nrpe_d_folder       = '/etc/nagios/nrpe.d'
      $plugins_packages    = [
                              'nagios-plugins-basic',
                              'nagios-plugins-standard',
                              'nagios-plugins-contrib'
                              ]
      $lmsensors_package   = 'lm-sensors'
      $binutils_package    = 'binutils'
    }
    default: {
      fail('This module only supports Debian-based systems')
    }
  }

  $ensure              = 'present'
  $ensure_running      = 'running'
  $ensure_enable       = 'true'
  $allowed_hosts       = ['127.0.0.1']
}
