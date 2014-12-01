class zabbix::server (
  $zabbix_url       = ' ', 
  $db_type          = $zabbix::params::db_type,
  $manage_repo      = $zabbix::params::manage_repo,
  $zabbix_version   = $zabbix::params::zabbix_version,
) inherits zabbix::params {
  
  
  case $db_type {
    'postgresql': {
      $db = 'pgsql'
    }
    'mysql': {
      $db = 'mysql'
    }
    default: {
      fail('$db_type is not recognized as a database type for Zabbix.')
    }
  }
  
  if $manage_repo {
    if ! defined(Class['zabbix::repo']) {
      class { 'zabbix::repo':
        zabbix_version => $zabbix_version,
      }
    }
    Package["zabbix-server-${db}"] {require => Class['zabbix::repo']}
  }
  
  package { "zabbix-server-${db}":
    ensure  => present,
  }

}