class icinga2::web(
  $frontend_users = $icinga2::frontend_users,
  ) inherits icinga2 {
  include icinga2::web::package
  #include icinga2::web::config
}
