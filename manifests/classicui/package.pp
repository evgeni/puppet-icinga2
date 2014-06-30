class icinga2::classicui::package(
  $ensure = hiera('ensure', $icinga2::params::ensure),
  ) inherits icinga2::params {

  ensure_packages($icinga2::params::classicui_package,
    {
    ensure  => $ensure,
    require => Apt::Source['debmon_org'],
    }
  )

}
