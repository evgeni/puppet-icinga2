class icinga2::config() {

  file { '/etc/icinga2/conf.d/puppet/':
    ensure  => directory,
    mode    => '0644',
    recurse => true,
    purge   => true,
    force   => true,
    require => Package['icinga2'],
  }

  file { '/etc/icinga2/conf.d/puppet/hosts/':
    ensure  => directory,
    mode    => '0644',
    require => File['/etc/icinga2/conf.d/puppet/'],
  }

  Icinga2::Object::Host <<| |>> {
    notify => [Service['icinga2']],
  }

  Icinga2::Object::Service <<| |>> {
    notify => [Service['icinga2']],
  }

  Icinga2::Object::Servicegroup <<| |>> {
    notify => [Service['icinga2']],
  }

  Icinga2::Object::Dependency <<| |>> {
    notify => [Service['icinga2']],
  }
}
