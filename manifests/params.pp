class zabbix::params {
  
  $db_type            = 'postgresql'
  $manage_repo        = true 
  $manage_vhost       = true
  $zabbix_version     = '2.4'
  $zabbix_timezone    = 'Europe/Amsterdam'
  $zabbix_url         = 'zabbix'
  $include_dir        = '/etc/zabbix/zabbix_server.conf.d'
  $listen_port        = undef
  $dbhost             = 'localhost'
  $dbname             = 'zabbix'
  $dbschema           = ''
  $dbuser             = 'zabbix'
  $dbpassword         = 'zabbix'
  $dbport             = '5432'
  $apache_use_ssl     = false
  $apache_ssl_key     = undef
  $apache_ssl_cert    = undef
  $apache_ssl_cipher  = 'ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128:AES256:AES:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK'
  $apache_ssl_chain   = undef
  
}