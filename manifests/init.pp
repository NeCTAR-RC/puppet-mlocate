# == Class: mlocate
#
# Install and manage the mlocate package.
#
# === Parameters
#
# [*package_name*]
#   The name of the package to install. Default: mlocate
#
# [*package_ensure*]
#   Ensure the package is present, latest, or absent. Default: present
#
# [*update_command*]
#   The name of the updatedb wrapper script. Default: /usr/local/bin/mlocate.cron
#
# [*deploy_update_command*]
#   If true the puppet module will deploy update_command script. Default: true
#
# [*update_on_install*]
#   Run an initial update when the package is installed. Default: true
#
# [*conf_file*]
#   The configuration file for updatedb. Default: /etc/updatedb.conf
#
# [*cron_ensure*]
#   Ensure the cron jobs is present or absent. Default: present
#
# [*cron_schedule*]
#   The standard cron time schedule. Default: once a week based on fqdn_rand
#
# [*cron_daily_path*]
#   The path to cron.daily file installed by mlocate and that is removed.
#
# [*cron_daily_ensure*]
#   Ensure original daily cron job present or absent. Default: absent
#
# [*prune_bind_mounts*]
#   Prune out bind mounts or not. Default: yes
#   Refer to the updatedb.conf man page for more detail.
#
# [*prunenames*]
#   Prune out directories matching this pattern. Default: .git .hg .svn
#   Refer to the updatedb.conf man page for more detail.
#
# [*extra_prunenames*]
#   Prune out additional directories matching this pattern. Default: none
#
# [*prunefs*]
#   Prune out these FS types. Default: refer to the params.pp
#   Refer to the updatedb.conf man page for more detail.
#
# [*extra_prunefs*]
#   Prune out additional directories matching this pattern. Default: none
#
# [*prunepaths*]
#   Prune out paths matching this pattern. Default: refer to params.pp
#   Refer to the updatedb.conf man page for more detail.
#
# [*extra_prunepaths*]
#   Prune out additional directories matching this pattern. Default: none
#
# === Examples
#
#  # Install a config that matches a modern RH system
#  include ::mlocate
#
#  # Prune some extra paths
#  class { '::mlocate':
#    extra_prunepaths = [ '/nas', '/exports' ],
#  }
#
# === Authors
#
# Adam Crews <Adam.Crews@gmail.com>
#
# === Copyright
#
# Copyright 2014 Adam Crews, unless otherwise noted.
#
class mlocate (
  String                              $package_name          = $mlocate::params::package_name,
  Enum['present', 'latest', 'absent'] $package_ensure        = $mlocate::params::package_ensure,
  String                              $update_command        = $mlocate::params::update_command,
  Boolean                             $deploy_update_command = $mlocate::params::deploy_update_command,
  Boolean                             $update_on_install     = $mlocate::params::update_on_install,
  String                              $conf_file             = $mlocate::params::conf_file,

  Enum['present', 'absent'] $cron_ensure       = $mlocate::params::cron_ensure,
  String                    $cron_schedule     = $mlocate::params::cron_schedule,
  String                    $cron_daily_path   = $mlocate::params::cron_daily_path,
  Enum['present', 'absent'] $cron_daily_ensure = $mlocate::params::cron_daily_ensure,

  Enum['yes', 'no'] $prune_bind_mounts     = $mlocate::params::prune_bind_mounts,
  Array             $prunefs               = $mlocate::params::prunefs,
  Array             $extra_prunefs         = [],
  Optional[Array]   $prunenames            = $mlocate::params::prunenames,
  Array             $extra_prunenames      = [],
  Array             $prunepaths            = $mlocate::params::prunepaths,
  Array             $extra_prunepaths      = [],
) inherits mlocate::params {

  anchor { 'mlocate::begin': }
  -> class { '::mlocate::install': }
  -> class { '::mlocate::cron': }
  -> anchor { 'mlocate::end': }
}
