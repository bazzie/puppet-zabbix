class zabbix::server (
  $zabbix_url       = ' ', 
  $db_type          = $zabbix::params::db_type,
  $manage_repo      = $zabbix::params::manage_repo,
  $zabbix_version   = $zabbix::params::zabbix_version,
  $include_dir      = $zabbix::params::include_dir,
  $listen_port      = $zabbix::params::listen_port,
  
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

  file { '/etc/zabbix/zabbix_server.conf':
    ensure  => present,
    owner   => 'zabbix',
    group   => 'zabbix',
    mode    => '0640',
    notify  => Service['zabbix-server'],
    require => Package["zabbix-server-${db}"],
    replace => true,
    content => template('zabbix/zabbix_server.conf.erb'),
  }

  file { '/etc/zabbix/web/zabbix.conf.php':
    ensure  => present,
    owner   => 'zabbix',
    group   => 'zabbix',
    mode    => '0644',
    notify  => Service['zabbix-server'],
    replace => true,
    content => template('zabbix/zabbix.conf.php.erb'),
  }

  file { $include_dir:
    ensure  => directory,
    owner   => 'zabbix',
    group   => 'zabbix',
    require => File['/etc/zabbix/zabbix_server.conf'],
  }

}