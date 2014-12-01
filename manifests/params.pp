class zabbix::params {
  
  $db_type        = 'postgresql'
  $manage_repo    = true 
  $zabbix_version = '2.4'
  $include_dir    = '/etc/zabbix/zabbix_server.conf.d'
  $dbhost         = 'localhost'
  $dbname         = 'zabbix'
  $dbschema       = ''
  $dbuser         = 'zabbix'
  $dbpassword     = 'zabbix'
  $dbport         = '5432'

}