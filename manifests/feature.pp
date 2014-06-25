define icinga2::feature(
  $ensure = 'link'
) {

  file { "/etc/icinga2/features-enabled/${name}.conf":
    ensure  => $ensure,
    path    => "/etc/icinga2/features-enabled/${name}.conf",
    target  => "/etc/icinga2/features-available/${name}.conf",
    notify  => Service['icinga2'],
  }

}
