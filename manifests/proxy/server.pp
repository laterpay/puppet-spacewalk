class spacewalk::proxy::server {

    include spacewalk::proxy::config

    service { spacewalk-proxy :
        enable     => true,
        ensure     => running,
        hasstatus  => true,
        hasrestart => true,
    }

}
