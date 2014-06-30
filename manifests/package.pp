class icinga2::package(
  $ensure = hiera('ensure', $icinga2::params::ensure),
  ) inherits icinga2::params {

  apt::source { 'debmon_org':
    location   => 'http://debmon.org/debmon',
    release    => 'debmon-wheezy',
    repos      => 'main',
    key        => 'DC0EE15A29D662D2',
    key_source => 'http://debmon.org/debmon/repo.key',
  }

  ensure_packages($icinga2::params::icinga2_package,
    {
    ensure  => $ensure,
    alias   => 'icinga2',
    require => Apt::Source['debmon_org'],
    }
  )

  ensure_packages($icinga2::params::nrpe_plugin_package,
    {
    ensure  => $ensure,
    alias   => 'nrpe-plugin',
    }
  )

}
