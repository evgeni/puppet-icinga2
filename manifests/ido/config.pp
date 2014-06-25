class icinga2::ido::config(
  $ensure = hiera('ensure', $icinga2::params::ensure),
  ) inherits icinga2::params {

  icinga2::feature { $icinga2::ido::ido_module:
    ensure  => $ensure,
    notify  => Service['icinga2'],
  }

}
