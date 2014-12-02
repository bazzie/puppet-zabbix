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

  if $manage_vhost {
    include apache
    # Check if we use ssl. If so, we also create an non ssl
    # vhost for redirect traffic from non ssl to ssl site.
    if $apache_use_ssl {
      # Listen port
      $apache_listen_port = '443'
 
      # We create nonssl vhost for redirecting non ssl
      # traffic to https.
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
      # So no ssl, so default port 80
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