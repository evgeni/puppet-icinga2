define icinga2::object::servicegroup (
  $servicegroup_name = $title,
  $display_name      = $title,
  $groups            = false,
  $target            = "/etc/icinga2/conf.d/puppet/servicegroups.conf",
  ) {
  
  if ! defined(Concat["${target}"]) {
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
    content => template('icinga2/object/servicegroup.erb'),
    order   => '02'
  } 
}
