class zabbix::proxy (
  $db_type                 = $zabbix::params::db_type,
  $zabbix_version          = $zabbix::params::zabbix_version,
  $manage_database         = $zabbix::params::manage_database,
  $manage_firewall         = $zabbix::params::manage_firewall,
  $manage_repo             = $zabbix::params::manage_repo,
  $use_ip                  = $zabbix::params::proxy_use_ip,
  $zbx_templates           = $zabbix::params::proxy_zbx_templates,
  $mode                    = $zabbix::params::proxy_mode,
  $zabbix_server           = $zabbix::params::zabbix_server,
  $zabbix_server_host      = $zabbix::params::proxy_zabbixhost,
  $zabbix_server_port      = $zabbix::params::proxy_zabbixport,
  $listenport              = $zabbix::params::proxy_listenport,
  $sourceip                = $zabbix::params::proxy_sourceip,
  $dbhost                  = $zabbix::params::proxy_dbhost,
  $dbname                  = $zabbix::params::proxy_dbname,
  $dbuser                  = $zabbix::params::proxy_dbuser,
  $dbpassword              = $zabbix::params::proxy_dbpassword,
  $dbport                  = $zabbix::params::proxy_dbport,
  
) inherits zabbix::params {
  
  case $db_type {
    'postgresql': {
      $db = 'pgsql'
    }
  default: {
     fail("Database type not recognized: ${db_type}")
  }
 }

 if $manage_repo {
   if ! defined(Class['zabbix::repo']) {
      class { 'zabbix::repo':
        zabbix_version => $zabbix_version,
      }
   }
   Package["zabbix-proxy-${db}"] {require => Class['zabbix::repo']}
}

  package { 'zabbix-proxy':
    ensure => present,
    require => Package["zabbix-proxy-${db}"]
  }

  package { "zabbix-proxy-${db}":
    ensure => present,
  }

  service { 'zabbix-proxy':
    ensure => running,
    hasstatus => true,
    hasrestart => true,
    require => [Package["zabbix-proxy-${db}"], File[$include_dir], File['/etc/zabbix/zabbix_proxy.conf']],
  }

  file { '/etc/zabbix/zabbix_proxy.conf':
    ensure => present,
    owner => 'zabbix',
    group => 'zabbix',
    mode => '0644',
    notify => Service['zabbix-proxy'],
    require => Package["zabbix-proxy-${db}"],
    replace => true,
    content => template('zabbix/zabbix_proxy.conf.erb'),
  }

  file { $include_dir:
    ensure => directory,
    require => File['/etc/zabbix/zabbix_proxy.conf'],
  }
}