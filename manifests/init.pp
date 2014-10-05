# == Class: icinga2
#
# Full description of class icinga2 here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { icinga2:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2014 Your name here, unless otherwise noted.
#
class icinga2 (
  $ensure           = hiera('ensure', $icinga2::params::ensure),
  $ensure_enable    = hiera('ensure_enable', $icinga2::params::ensure_enable),
  $ensure_running   = hiera('ensure_running', $icinga2::params::ensure_running),
  $frontend         = hiera('icinga2::frontend', $icinga2::params::frontend),
  $frontend_users   = hiera('icinga2::frontend_users', $icinga2::params::frontend_users),
  $backend          = hiera('icinga2::backend', $icinga2::params::backend),
) inherits icinga2::params {

  include icinga2::package
  include icinga2::service
  include icinga2::config

  case $frontend {
    classicui: {
      include icinga2::classicui
    }
    web: {
      include icinga2::ido
      include icinga2::web
    }
    default: { }
  }
  icinga2::object::servicegroup { 'libs': }
  icinga2::object::servicegroup { 'kernel': }
  icinga2::object::servicegroup { 'packages': }
  icinga2::object::servicegroup { 'fs': }

  icinga2::object::servicegroup { 'cert': }

  icinga2::object::command { 'ssl_cert':
    command_line => 'PluginDir + "/check_ssl_cert"',
    args         => {
      "-H" => '$ssl_cert_hostname$',
      "-P" => '$ssl_cert_protocol$',
      "-p" => '$ssl_cert_port$',
      "-w" => '$ssl_cert_warn$',
      "-c" => '$ssl_cert_crit$',
      "-r" => '$ssl_cert_rootcert$',
    },
    vars         => {
      "ssl_cert_warn"     => "14",
      "ssl_cert_crit"     => "7",
      "ssl_cert_rootcert" => "/etc/ssl/certs/ca-certificates.crt",
    },
  }

  icinga2::object::command { 'jabber':
    command_line => 'PluginDir + "/check_jabber"',
    args         => {
      "-H" => '$jabber_hostname$',
    },
    vars         => {
      "jabber_hostname"     => '$address$',
    },
  }
}
