# == Class: icinga2::host
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
#  class { icinga2::host:
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
class icinga2::host (
  $address = $::ipaddress,
  $address6 = $::ipaddress6,
  $check_disk_ignore = hiera_array('icinga2::host::check_disk_ignore', []),
) inherits icinga2::params {

  include icinga2::nrpe

  $ensure = present

  @@icinga2::object::host{ $::fqdn:
    address  => $address,
    address6 => $address6,
  }

  @@icinga2::object::service { "${::fqdn}_libs":
    service_name  => 'libs',
    host_name     => $::fqdn,
    check_command => 'nrpe',
    vars          => { nrpe_command => 'check_libs' },
  }

  if $::virtual != 'openvzve' {
    ensure_packages($icinga2::params::binutils_package)
    @@icinga2::object::service { "${::fqdn}_kernel":
      service_name  => 'kernel',
      host_name     => $::fqdn,
      check_command => 'nrpe',
      vars          => { nrpe_command => 'check_running_kernel'} ,
    }
  }

  if $::osfamily == 'Debian' {
    @@icinga2::object::service { "${::fqdn}_packages":
      service_name  => 'packages',
      host_name     => $::fqdn,
      check_command => 'nrpe',
      vars          => { nrpe_command => 'check_packages'},
    }

    $check_packages_ignore = hiera_array('icinga2::host::check_packages_ignore', [])

    file { '/etc/nagios-plugins/obsolete-packages-ignore.d/puppet-icinga2-ignores':
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => Package['nagios-plugins-contrib'],
      content => template('icinga2/etc/nagios-plugins/obsolete-packages-ignore.d/puppet-icinga-ignores.erb'),
    }
  }

  @@icinga2::object::service { "${::fqdn}_entropy":
    service_name  => 'entropy',
    host_name     => $::fqdn,
    check_command => 'nrpe',
    vars          => { nrpe_command => 'check_entropy'},
  }

  if $::virtual != 'openvzve' {
    icinga2::nrpe::command { 'check_ntp_peer':
      command_line => '/usr/lib/nagios/plugins/check_ntp_peer -H localhost -w 1 -c 2'
    }

    @@icinga2::object::service { "${::fqdn}_ntp":
      service_name  => 'ntp',
      host_name     => $::fqdn,
      check_command => 'nrpe',
      vars          => { nrpe_command => 'check_ntp_peer'},
    }
  }

  $a_mounts = difference(split($::mounts, ','), $check_disk_ignore)
  $disk_limits = hiera('icinga2::host::disk_limits', {})

  file { "${icinga2::params::nrpe_d_folder}/disk.cfg":
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Service[$icinga2::params::nrpe_service],
    require => File[$icinga2::params::nrpe_d_folder],
    content => template('icinga2/etc/nagios/nrpe.d/disk.cfg.erb'),
  }

  icinga2::object::service_parametrized { $a_mounts:
    check_command => 'nrpe',
    command       => 'check_disk_',
    groups        => 'fs',
  }


  if $::virtual == 'physical' {

    $a_disks = split($::disks, ',')
    file { "${icinga2::params::nrpe_d_folder}/smart.cfg":
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      notify  => Service[$icinga2::params::nrpe_service],
      require => File[$icinga2::params::nrpe_d_folder],
      content => template('icinga2/etc/nagios/nrpe.d/smart.cfg.erb'),
    }
    icinga2::object::service_parametrized { $a_disks:
      check_command => 'nrpe',
      command       => 'check_ide_smart_',
      groups        => 'disk',
    }

    ensure_packages($icinga2::params::lmsensors_package)
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
