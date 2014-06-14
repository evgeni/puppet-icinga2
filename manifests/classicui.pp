class icinga2::classicui(
  $frontend_users = $icinga2::frontend_users,
  ) inherits icinga2 {
  include icinga2::classicui::package
  include icinga2::classicui::config
}
