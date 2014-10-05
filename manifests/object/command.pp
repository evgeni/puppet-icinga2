# define: icinga2::object::command
define icinga2::object::command (
  $command_line,
  $command_name   = $title,
  $args           = {},
  $vars           = {},
  $target         = '/etc/icinga2/conf.d/puppet/commands.conf',
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
    content => template('icinga2/object/command.erb'),
    order   => '02'
  }
}
