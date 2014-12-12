class zabbix::server(
  $zabbix_version          = $zabbix::params::zabbix_version,
  $zabbix_timezone         = $zabbix::params::zabbix_timezone,
  $manage_database         = $zabbix::params::manage_database,
  $manage_repo             = $zabbix::params::manage_repo,
  $db_name                 = $zabbix::params::db_name,
  $db_user                 = $zabbix::params::db_user,
  $db_pass                 = $zabbix::params::db_pass,
  $db_host                 = $zabbix::params::db_host,
) inherits zabbix::params {
  
  $include_dir             = '/etc/zabbix/zabbix_server.conf.d'
  
  if $manage_repo {
    if ! defined(Class['zabbix::repo']) {
      class { 'zabbix::repo':
        zabbix_version => $zabbix_version,
      }
    }
    Package["zabbix-server-pgsql"] {require => Class['zabbix::repo']}
  }

  package { "zabbix-server-pgsql":
    ensure  => present,
  }
    
  class { 'zabbix::database':
          zabbix_type    => 'server',
          zabbix_version => $zabbix_version,
          db_name        => $db_name,
          db_user        => $db_user,
          db_pass        => $db_pass,
          db_host        => $db_host,
        }

  service { 'zabbix-server':
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    require    => [
      Package["zabbix-server-pgsql"],
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
    require => Package["zabbix-server-pgsql"],
    replace => true,
    content => template('zabbix/zabbix_server.conf.erb'),
  }

  file { $include_dir:
    ensure  => directory,
    owner   => 'zabbix',
    group   => 'zabbix',
    require => File['/etc/zabbix/zabbix_server.conf'],
  }

}