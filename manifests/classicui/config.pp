class icinga2::classicui::config(
  $ensure = hiera('ensure', $icinga2::params::ensure),
  ) inherits icinga2::params {

  $frontend_users = $icinga2::frontend_users

  file { '/etc/icinga2/classicui/htpasswd.users':
    ensure  => $ensure,
    content => template('icinga2/classicui/htpasswd.users.erb'),
    require => Package['icinga2-classicui'],
  }

}

