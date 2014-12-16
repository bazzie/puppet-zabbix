class zabbix::postgresql(
  $mytype = "myType", 
){
  
  notify {'$mytype':}
  
}