class zabbix::web (
  
  $db_type          = $zabbix::params::db_type,
  $zabbix_url       = $zabbix::params::zabbix_url,
  
  
  
  
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
    Package["zabbix-web-${db}"] {require => Class['zabbix::repo']}
  }
  
  user {'zabbix':
     ensure => present,
     managehome => true,
     before => Package['zabbix-web']
  }
  
  
  package { "zabbix-web-${db}":
    ensure  => present,
     before  => [
      File['/etc/zabbix/web/zabbix.conf.php'],
        Package['zabbix-web']
      ],
  }
      
  package { 'zabbix-web':
    ensure => present,
  }
  
  
  file { '/etc/zabbix/web/zabbix.conf.php':
    ensure  => present,
    owner   => 'zabbix',
    group   => 'zabbix',
    mode    => '0644',
    replace => true,
    content => template('zabbix/zabbix.conf.php.erb'),
  }
  
  if $manage_vhost {
    include apache
    
    class { 'apache::mod::php': 
      content => '
        AddHandler php5-script .php
        AddType text/html .php',
        path  => "${::apache::params::lib_path}/libphp5.so",
    }
    
    if $apache_use_ssl {
      $apache_listen_port = '443'
 
      apache::vhost { "${zabbix_url}_nonssl":
        docroot        => '/usr/share/zabbix',
        manage_docroot => false,
        port           => '80',
        servername     => $zabbix_url,
        ssl            => false,
        rewrites       => [
          {
            comment      => 'redirect all to https',
            rewrite_cond => ['%{SERVER_PORT} !^443$'],
            rewrite_rule => ["^/(.+)$ https://${zabbix_url}/\$1 [L,R]"],
          }
        ],
      }
    } else {
      $apache_listen_port = '80'
    }

    apache::vhost { $zabbix_url:
      docroot         => '/usr/share/zabbix',
      port            => $apache_listen_port,
      directories     => [
        { path     => '/usr/share/zabbix',
          provider => 'directory',
          allow    => 'from all',
          order    => 'Allow,Deny',
        },
        { path     => '/usr/share/zabbix/conf',
          provider => 'directory',
          deny     => 'from all',
          order    => 'Deny,Allow',
        },
        { path     => '/usr/share/zabbix/api',
          provider => 'directory',
          deny     => 'from all',
          order    => 'Deny,Allow',
        },
        { path     => '/usr/share/zabbix/include',
          provider => 'directory',
          deny     => 'from all',
          order    => 'Deny,Allow',
        },
        { path     => '/usr/share/zabbix/include/classes',
          provider => 'directory',
          deny     => 'from all',
          order    => 'Deny,Allow',
        },
      ],
      custom_fragment => "  php_value max_execution_time 300
        php_value memory_limit 128M
        php_value post_max_size 16M
        php_value upload_max_filesize 2M
        php_value max_input_time 300
        php_value date.timezone ${zabbix_timezone}",
        rewrites   => [ { rewrite_rule    => ['^$ /index.php [L]'] } ],
        ssl        => $apache_use_ssl,
        ssl_cert   => $apache_ssl_cert,
        ssl_key    => $apache_ssl_key,
        ssl_cipher => $apache_ssl_cipher,
        ssl_chain  => $apache_ssl_chain,
    }
  }
  
}