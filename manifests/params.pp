class zabbix::params {
  #General parameters
  $manage_vhost            = true
  $zabbix_version          = '2.4'
  $zabbix_timezone         = 'Europe/Amsterdam'
  $zabbix_url              = 'zabbix'
  $zabbix_server           = 'zabbix'
  
  $db_type          = 'postgresql'
  $db_host          = 'localhost'
  $db_name          = 'zabbix'
  $db_schema        = ''
  $db_user          = 'zabbix'
  $db_pass          = 'zabbix'
  $db_port          = '5432'
  $manage_database  = true
  $manage_firewall  = false
  $manage_repo      = true 
  $listen_port      = '10051'
}

