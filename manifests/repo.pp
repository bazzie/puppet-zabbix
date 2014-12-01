class zabbix::repo(
  $zabbix_version
) {
  
  yumrepo { 'zabbix':
        name     => "Zabbix_${::operatingsystemmajrelease}_${::architecture}",
        descr    => "Zabbix_${::operatingsystemmajrelease}_${::architecture}",
        baseurl  => "http://repo.zabbix.com/zabbix/${zabbix_version}/rhel/${::operatingsystemmajrelease}/${::architecture}/",
        gpgcheck => '1',
        gpgkey   => 'http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX',
        priority => '1',
      }
 
   yumrepo { 'zabbix-nonsupported':
        name     => "Zabbix_nonsupported_${::operatingsystemmajrelease}_${::architecture}",
        descr    => "Zabbix_nonsupported_${::operatingsystemmajrelease}_${::architecture}",
        baseurl  => "http://repo.zabbix.com/non-supported/rhel/${::operatingsystemmajrelease}/${::architecture}/",
        gpgcheck => '1',
        gpgkey   => 'http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX',
        priority => '1',
      }

}