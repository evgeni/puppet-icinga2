# == Class: icinga::host
#
# Install and configure an Icinga client: a NRPE enabled host.
# This will export several nagios_* ressources to be collected by the
# Icinga server.
#
# === Parameters
#
# None
#
# === Examples
#
#  class { icinga::host:
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
class icinga2::host {

  $ensure = present

  @@icinga2::object::host{ $::fqdn:
    address  => $::ipaddress,
    address6 => $::ipaddress6,
  }

  @@icinga2::object::service { "${::fqdn}_libs":
    service_name  => 'libs',
    host_name     => $::fqdn,
    check_command => 'nrpe',
    vars          => { nrpe_command => 'check_libs' },
  }

  if $::virtual != 'openvzve' {
    @@icinga2::object::service { "${::fqdn}_kernel":
      service_name  => 'kernel',
      host_name     => $::fqdn,
      check_command => 'nrpe',
      vars          => { nrpe_command => 'check_running_kernel'} ,
    }
  }

  @@icinga2::object::service { "${::fqdn}_packages":
    service_name  => 'packages',
    host_name     => $::fqdn,
    check_command => 'nrpe',
    vars          => { nrpe_command => 'check_packages'},
  }

  @@icinga2::object::service { "${::fqdn}_entropy":
    service_name  => 'entropy',
    host_name     => $::fqdn,
    check_command => 'nrpe',
    vars          => { nrpe_command => 'check_entropy'},
  }

  if $::virtual != 'openvzve' {
    @@icinga2::object::service { "${::fqdn}_ntp":
      service_name  => 'ntp',
      host_name     => $::fqdn,
      check_command => 'nrpe',
      vars          => { nrpe_command => 'check_ntp_peer'},
    }
  }

  $a_mounts = split($::mounts, ',')
  $disk_limits = hiera('icinga2::host::disk_limits', {})

  icinga2::object::service_parametrized { $a_mounts:
    check_command => 'nrpe',
    command       => 'check_disk_',
    groups        => 'fs',
  }


  if $::virtual == 'physical' {

    $a_disks = split($::disks, ',')
    icinga2::object::service_parametrized { $a_disks:
      check_command => 'nrpe',
      command       => 'check_ide_smart_',
      groups        => 'disk',
    }

    @@icinga2::object::service { "${::fqdn}_sensors":
      service_name  => 'sensors',
      host_name     => $::fqdn,
      check_command => 'nrpe',
      vars          => { nrpe_command => 'check_sensors'},
    }
  }

  $services = hiera('icinga2::host::services', {})
  $defaults = { host_name => $::fqdn }
  $services_k = keys($services)
  icinga2::object::service_generated { $services_k: config => $services; }
  #create_resources('@@icinga2::object::service', $services, $defaults)

}
