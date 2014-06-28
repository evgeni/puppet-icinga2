# define: icinga2::nrpe::command
#
# This definition creates NRPE command snipets and places them (by default)
# in a file in the nrpe.d directory.
# That can be used to install NRPE commands from your manifests.
define icinga2::nrpe::command(
  $command_line,
  $command_name = $name,
  $ensure       = present,
  $group        = 'root',
  $mode         = '0644',
  $owner        = 'root',
  $target       = "${icinga2::params::nrpe_d_folder}/${name}.cfg",
  ) {
  file { $target:
    ensure  => $ensure,
    path    => $target,
    group   => $group,
    mode    => $mode,
    owner   => $owner,
    content => template('icinga2/etc/nagios/nrpe.d/command.cfg.erb'),
    notify  => Service[$icinga2::params::nrpe_service],
    require => File[$icinga2::params::nrpe_d_folder],
  }
}
