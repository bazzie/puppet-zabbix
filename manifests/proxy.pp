class zabbix::proxy(
  
  $zabbix_version          = $zabbix::params::zabbix_version,
  $manage_database         = $zabbix::params::manage_database,
  $manage_repo             = $zabbix::params::manage_repo,
  $db_name                 = $zabbix::params::db_name,
  $db_user                 = $zabbix::params::db_user,
  $db_pass                 = $zabbix::params::db_pass,
  $db_host                 = $zabbix::params::db_host,
  
) inherits zabbix::params {
  
  
    if $manage_repo {
    if ! defined(Class['zabbix::repo']) {
      class { 'zabbix::repo':
        zabbix_version => $zabbix_version,
      }
    }
    Package["zabbix-proxy-pgsql"] {require => Class['zabbix::repo']}
  }
  
  package { "zabbix-proxy-pgsql":
        ensure  => present,
      }
  
  package { 'zabbix-proxy':
        ensure  => present,
        require => Package["zabbix-proxy-pgsql"]
      }
 
   class { 'zabbix::database':
     zabbix_type    => 'proxy',
     zabbix_version => $zabbix_version,
     db_name        => $db_name,
     db_user        => $db_user,
     db_pass        => $db_pass,
     db_host        => $db_host,
   }
  
    file { '/etc/zabbix/zabbix_proxy.conf':
    ensure  => present,
    owner   => 'zabbix',
    group   => 'zabbix',
    mode    => '0644',
    notify  => Service['zabbix-proxy'],
    require => Package["zabbix-proxy-pgsql"],
    replace => true,
    content => template('zabbix/zabbix_proxy.conf.erb'),
  }
  
}