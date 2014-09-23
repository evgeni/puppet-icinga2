# icinga2

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with icinga2](#setup)
    * [What icinga2 affects](#what-icinga2-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with icinga2](#beginning-with-icinga2)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This module installs and configures Icinga2 servers and clients on Debian.
It's designed to work with Puppet 2.7+.

## Module Description

Using this module, you can install a full Icinga2 stack, with the main
daemon, IDO backends and various interfaces. It will install packages from
the [debmon.org](http://debmon.org) repository, configure the needed services
and collect exported resources (hosts, services, etc) from clients.

On clients, this module will install and configure NRPE and export
various services checks for the server to collect.

## Setup

### What icinga2 affects

On an Icinga2 server:

* Add the [debmon.org](http://debmon.org) repository
* Installs the icinga2 and nrpe-plugin packages
* Sets up the icinga2 service
* Collects exported Icinga2 resources into /etc/icinga2/conf.d/puppet/
* Installs and configures either icinga2-classicui or icinga-web as a frontend
* In the case of icinga-web, icinga2-ido is installed and configured

On an Icinga2 client:

* Installs the nrpe-server package
* Configures the nrpe-server to accept connections from the Icinga2 server
* Installs several nrpe checks
* Exports the checks as Icinga2 resources to be collected by the server

### Setup Requirements

You should have `pluginsync = true` and `storeconfigs = true` in your `puppet.conf`.

### Beginning with icinga2

When you want to install an Icinga2 server, a `include icinga2` should be enough.
For a client, use `include icinga2::host`.

Configuration can be done using parameters to the classes, but using hiera is preferred.

## Usage

FIXME: Put the classes, types, and resources for customizing, configuring, and doing
the fancy stuff with your module here.

### Hiera

This module can be fully configured via Hiera. Examples for server and client follow:

#### server.yaml

    # Install Icinga2 ClassicUI ("classicui") or Icinga Web ("web") as the frontend
    icinga2::frontend: classicui
    # Wich users to create for the frontend
    icinga2::frontend_users:
      icingaadmin: "<some-htpasswd-hash>"
      otheruser: "<different-hash>"
    # In the case of Icinga Web, which IDO backend should be used, PostgreSQL ("pgsql") or MySQL ("mysql")
    icinga2::backend: pgsql

#### client.yaml

    # Which hosts are allowed to query via NRPE
    icinga2::nrpe::allowed_hosts:
      - 127.0.0.1
      - 192.0.2.123

    # Which packages should be ignored by the check_packages check
    icinga2::host::check_packages_ignore:
      - example
      - hello

    # Override disk warning/critical limits for a specific mount point
    icinga2::host::disk_limits:
      /srv:
        warn: 15%
        crit: 10%

    # Additional services for the host
    icinga2::host::services:
      <puppet-internal-name>: # must be unique
        service_name: mysql
        check_command: nrpe
        vars:
          nrpe_command: check_mysql

## Reference

FIXME: Here, list the classes, types, providers, facts, etc contained in your module.
This section should include all of the under-the-hood workings of your module so
people know what the module is touching on their system but don't need to mess
with things. (We are working on automating this section!)

## Limitations

Puppet 2.7+ and Debian Wheezy only currently, more to come.

## Development

Pull-requests are awesome. They are even more awesome if they include tests
for the functionality you add or alter.
