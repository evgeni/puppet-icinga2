define icinga2::feature(
  $ensure = 'link'
) {

  if $ensure == 'present' {
    $ensure_feature = 'link'
  }
  else {
    $ensure_feature = $ensure
  }

  file { "/etc/icinga2/features-enabled/${name}.conf":
    ensure  => $ensure_feature,
    path    => "/etc/icinga2/features-enabled/${name}.conf",
    target  => "/etc/icinga2/features-available/${name}.conf",
    notify  => Service['icinga2'],
  }

}
