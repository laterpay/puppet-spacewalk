class spacewalk::client::osad {

   Ini_setting {
      path    => '/etc/sysconfig/rhn/osad.conf',
      require => File['/etc/sysconfig/rhn/osad.conf'],
      section => 'osad',
    }

    ini_setting {'osa_ssl_cert':
       ensure  => present,
        setting => 'osa_ssl_cert',
        value   => '\/usr\/share\/rhn\/RHN-ORG-TRUSTED-SSL-CERT',
    }

    package { "osa-dispatcher" :
        ensure => installed,
        require => Class["spacewalk::client::setup"]
    }

    file { "/etc/sysconfig/rhn/osad.conf" :
        require => Package["osa-dispatcher"],
    }

    service { "osa-dispatcher" :
        enable => true,
        ensure => true,
        require => File["/etc/sysconfig/rhn/osad.conf"],
        subscribe => File["/etc/sysconfig/rhn/osad.conf"],
    }

    cron { "osad_restart" :
        command => "/sbin/service osa-dispatcher restart > /dev/null",
        user => "root",
        hour => 0,
        minute => 0,
    }

}

