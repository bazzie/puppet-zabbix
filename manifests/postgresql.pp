class zabbix::postgresql(
  $mytype = '', 
){
  
  notify {$mytype:}
  
}