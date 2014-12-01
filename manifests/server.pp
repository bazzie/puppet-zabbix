class zabbix::server (
  $zabbix_url       = ' ', 
  $db_type          = $zabbix::params::db_type,
  $manage_repo      = $zabbix::params::manage_repo,
  $zabbix_version   = $zabbix::params::zabbix_version,
  $include_dir      = $zabbix::params::include_dir,
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


  package { "zabbix-web-${db}":
    ensure  => present,
    require => Package["zabbix-server-${db}"],
    before  => [
      File['/etc/zabbix/web/zabbix.conf.php'],
        Package['zabbix-web']
      ],
  }
      
  package { 'zabbix-web':
    ensure => present,
  }

  Service['zabbix-server'] { enable     => true }

  service { 'zabbix-server':
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    require    => [
      Package["zabbix-server-${db}"],
      File[$include_dir],
      File['/etc/zabbix/zabbix_server.conf']
    ],
  }



}