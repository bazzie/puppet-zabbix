class zabbix::params {
  
  $db_type        = 'postgresql'
  $manage_repo    = true 
  $zabbix_version = '2.4'
  $dbhost         = 'localhost'
  $dbname         = 'zabbix'
  $dbschema       = ''
  $dbuser         = 'zabbix'
  $dbpassword     = 'zabbix'
  $dbport         = '5432'

}