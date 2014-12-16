class zabbix::postgresql(
  $mytype = 'fiets', 
){
  
  notify {$mytype:}
  
}