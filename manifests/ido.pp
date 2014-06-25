class icinga2::ido (
  $backend = $icinga2::backend,
  ) inherits icinga2 {

  case $backend {
    mysql: {
      $ido_package = $icinga2::params::ido_mysql_package
      $ido_module  = $icinga2::params::ido_mysql_module
    }
    pgsql: {
      $ido_package = $icinga2::params::ido_pgsql_package
      $ido_module  = $icinga2::params::ido_pgsql_module
    }
    default: {
      fail('Only MySQL and PostgreSQL backends are supported.')
    }
  }

  include icinga2::ido::package
  include icinga2::ido::config

}
