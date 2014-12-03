class zabbix::database(
  $manage_database = '',
  $db_type          = '',
  $zabbix_type     = '',
  $zabbix_version  = '',
  $db_name         = '',
  $db_user         = '',
  $db_pass         = '',
  $db_host         = '',
) {
  if $manage_database == true {
    case $db_type {
      'postgresql': {
        class { 'zabbix::postgresql':
          zabbix_type    => $zabbix_type,
          zabbix_version => $zabbix_version,
          db_name        => $db_name,
          db_user        => $db_user,
          db_pass        => $db_pass,
        }
      }
      
      default: {
        fail('Unrecognized database type for server.')
      }
    }
  }
}