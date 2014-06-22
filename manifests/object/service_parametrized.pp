# define: icinga2::object::service_parametrized
#
# This definition is a wrapper around icinga2::object::service.
# It allows definitions of services which need the name of the service
# as part of the check command, like filesystem and SMART checks.
define icinga2::object::service_parametrized($check_command = false, $command = false, $groups = false) {
  @@icinga2::object::service { "${::fqdn}_${name}":
    service_name  => $name,
    host_name     => $::fqdn,
    check_command => $check_command,
    vars          => { nrpe_command => "${command}${name}" },
    groups        => $groups,
  }
}
