class zabbix::database(
  $manage_database = '',
  $dbtype          = '',
  $zabbix_type     = '',
  $zabbix_version  = '',
  $db_name         = '',
  $db_user         = '',
  $db_pass         = '',
  $db_host         = '',
) {
  if $manage_database == true {
    case $dbtype {
      'postgresql': {
        class { 'zabbix::database::postgresql':
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