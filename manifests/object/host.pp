define icinga2::object::host (
  $host_name = $title,
  $address   = false,
  $address6  = false,
  $import    = 'generic-host',
  $os        = $::kernel,
  $sla       = '24x7',
  $target    = "/etc/icinga2/conf.d/puppet/hosts/${name}.conf",
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
    content => template('icinga2/object/host.erb'),
    order   => '02'
  }
}
