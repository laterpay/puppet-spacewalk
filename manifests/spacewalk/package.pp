class spacewalk::spacewalk::package {

    include epel

    package {
        'spacewalk-repo': 
            provider => rpm,
            ensure => installed, 
            source => 'http://yum.spacewalkproject.org/2.0/RHEL/6/x86_64/spacewalk-repo-2.0-3.el6.noarch.rpm',
            require => Class['epel'];
    }
    package {
        'spacewalk-setup-postgresql':
            ensure  => installed,
            require => Package['spacewalk-repo'];
    }
    package {
        'spacewalk-postgresql':
            ensure  => installed,
            require => Package['spacewalk-setup-postgresql'];
        'syslinux':
            ensure  => installed;
    }
    package {
        'spacecmd':
            ensure  => installed,
            require => Package['spacewalk-setup-postgresql'];
        'spacewalk-utils':
            ensure  => installed,
            require => Package['spacewalk-setup-postgresql'];
    }

    file {
        '/etc/yum.repos.d/jpackage-generic.repo':
            ensure  => file,
            owner   => 'root',
            group   => 'root',
            source  => 'puppet:///modules/spacewalk/jpackage-generic.repo';
    }


}
