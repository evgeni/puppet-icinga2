class icinga2::web::package(
  $ensure = hiera('ensure', $icinga2::params::ensure),
  ) inherits icinga2::params {

  package { $icinga2::params::web_package:
    ensure  => $ensure,
    require => [ Apt::Source['debmon_org'], Class['icinga2::ido::config'] ],
  }

}
