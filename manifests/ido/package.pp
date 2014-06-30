class icinga2::ido::package(
  $ensure = hiera('ensure', $icinga2::params::ensure),
  ) inherits icinga2::ido {

  ensure_packages($icinga2::ido::ido_package,
    {
    ensure  => $ensure,
    alias   => 'icinga2-ido',
    require => Apt::Source['debmon_org'],
    }
  )

}
