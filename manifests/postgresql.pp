class zabbix::postgresql(
  
  $db_user              = 'zabbix',
  $db_name              = 'zabbix',
  $db_pass              = 'zabbix',
  $cidr                 = '192.168.1.0/24',
  $method               = 'trust',
  $listen_address       = '*',
  $postgres_password    = '',  
  $type                 = 'host',

){
  
  class { 'postgresql::server':
    ip_mask_deny_postgres_user => '0.0.0.0/32',
    ip_mask_allow_all_users    => '0.0.0.0/0',
    listen_addresses           => '*',
    ipv4acls                   => ["$type $db_name $db_user $cidr $method"],
    postgres_password          => '$postgres_password',
  }

  postgresql::server::db { '$db_name':
    user     => '$db_user',
    password => postgresql_password('$db_user', '$db_pass'),
  }
  
}