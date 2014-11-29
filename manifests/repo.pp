class zabbix::repo(
  $zabbix_version
) {
  
  yumrepo { 'zabbix':
        name     => "Zabbix_${::majorrelease}_${::architecture}",
        descr    => "Zabbix_${::majorrelease}_${::architecture}",
        baseurl  => "http://repo.zabbix.com/zabbix/${zabbix_version}/rhel/${::majorrelease}/${::architecture}/",
        gpgcheck => '1',
        gpgkey   => 'http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX',
        priority => '1',
      }
 
   yumrepo { 'zabbix-nonsupported':
        name     => "Zabbix_nonsupported_${::majorrelease}_${::architecture}",
        descr    => "Zabbix_nonsupported_${::majorrelease}_${::architecture}",
        baseurl  => "http://repo.zabbix.com/non-supported/rhel/${::majorrelease}/${::architecture}/",
        gpgcheck => '1',
        gpgkey   => 'http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX',
        priority => '1',
      }

}