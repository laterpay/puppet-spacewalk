class spacewalk::spacewalk::server {

    include spacewalk::spacewalk::config

    file { '/etc/init.d/spacewalk-service':
        ensure => 'link',
        target => '/usr/sbin/spacewalk-service',
    }

    service { spacewalk-service :
        enable     => true,
        ensure     => running,
        hasstatus  => true,
        hasrestart => true,
    }

}
