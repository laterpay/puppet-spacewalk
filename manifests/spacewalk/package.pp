class spacewalk::spacewalk::package {

    include epel

    package {
        'spacewalk-repo': 
            provider => rpm,
            ensure => installed, 
            source => 'http://yum.spacewalkproject.org/1.9/RHEL/6/x86_64/spacewalk-repo-1.9-1.el6.noarch.rpm',
            require => Class['epel'];
    }
    package {
        'spacewalk-setup-embedded-postgresql':
            ensure  => installed,
            require => Package['spacewalk-repo'];
    }
    package {
        'spacewalk-postgresql':
            ensure  => installed,
            require => Package['spacewalk-setup-embedded-postgresql'];
        'syslinux':
            ensure  => installed;
    }
    package {
        'spacecmd':
            ensure  => installed,
            require => Package['spacewalk-setup-embedded-postgresql'];
        'spacewalk-utils':
            ensure  => installed,
            require => Package['spacewalk-setup-embedded-postgresql'];
    }

    file {
        '/etc/yum.repos.d/jpackage-generic.repo':
            ensure  => file,
            owner   => 'root',
            group   => 'root',
            source  => 'puppet:///modules/spacewalk/jpackage-generic.repo';
    }


}
