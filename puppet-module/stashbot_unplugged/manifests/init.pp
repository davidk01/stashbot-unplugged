# == Class: unplugged
#
# Full description of class unplugged here.
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
#  class { 'unplugged':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2015 Your name here, unless otherwise noted.
#
class stashbot_unplugged {
  file {
    '/usr/local/bin/installer.sh':
      ensure => 'file',
      source => 'puppet:///modules/stashbot_unplugged/installer.sh',
      owner => 'root',
      group => 'root',
      mode => '0744',
      notify => Exec['run_installer'],
  }
  exec {
    'run_installer':
      command => '/usr/local/bin/installer.sh',
      refreshonly => true,
  }
}
