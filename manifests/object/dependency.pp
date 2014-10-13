define icinga2::object::dependency (
  $parent_host_name,
  $dependency_name       = $title,
  $parent_service_name   = false,
  $child_host_name       = false,
  $child_service_name    = false,
  $disable_checks        = false,
  $disable_notifications = true,
  $period                = false,
  $states                = false,
  $target                = '/etc/icinga2/conf.d/puppet/dependencies.conf',
  ) {

  if ! defined(Concat[$target]) {
    concat { $target:
      ensure         => present,
      ensure_newline => true,
    }
  }

  if ! defined(Concat::Fragment["${target}_header"]) {
    concat::fragment { "${target}_header":
      target  => $target,
      content => '# THIS FILE IS MANAGED BY PUPPET',
      order   => '01'
    }
  }

  concat::fragment { "${target}_${name}":
    target  => $target,
    content => template('icinga2/object/dependency.erb'),
    order   => '02'
  }
}

