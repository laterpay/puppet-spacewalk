class spacewalk::spacewalk::server {

    include spacewalk::spacewalk::config

    file { '/etc/init.d/spacewalk-service':
        ensure => 'link',
        target => '/usr/sbin/spacewalk-service',
    }

    # enable = false because -> service spacewalk-service does not support chkconfig
    service { spacewalk-service :
        enable     => false,
        ensure     => running,
        hasstatus  => true,
        hasrestart => true,
    }

}
