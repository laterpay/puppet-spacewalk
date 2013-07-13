class spacewalk::centos_errata::config {

    include spacewalk::centos_errata::package

    file {
        '/opt/Centos-Errata':
            ensure  => directory;
        '/opt/Centos-Errata/centos-errata.sh':
            ensure  => file,
            mode    => '0700',
            source  => 'puppet:///modules/spacewalk/centos_errata/centos-errata.sh',
            require => File['/opt/Centos-Errata'];
        '/opt/Centos-Errata/centos-errata.py':
            ensure  => file,
            source  => 'puppet:///modules/spacewalk/centos_errata/centos-errata.py',
            require => File['/opt/Centos-Errata'];
        '/opt/Centos-Errata/centos6-errata.cfg':
            ensure  => file,
            source  => 'puppet:///modules/spacewalk/centos_errata/centos6-errata.cfg',
            require => File['/opt/Centos-Errata'];
    }
        
    cron {
        'Centos Errata':
            ensure	=> present,
            command     => '/opt/Centos-Errata/centos-errata.sh > /dev/null 2>&1',
            user        => 'root',
            hour        => '7',
            minute      => '0';
    }

}
