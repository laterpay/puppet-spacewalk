class spacewalk::client::setup ( 
    $server_url,
    $keys,
    $version,
    $spacewalk_client_repo = hiera('spacewalk_client_repo','http://yum.spacewalkproject.org/2.2-client/RHEL/6/$basearch/'),
    $spacewalk_client_repo_gpg = hiera('spacewalk_client_repo_gpg','http://yum.spacewalkproject.org/RPM-GPG-KEY-spacewalk-2012'),
    $ssl_ca_cert = '/usr/share/rhn/RHN-ORG-TRUSTED-SSL-CERT',
    $wipe_reposd  = false
    ) {

    $version_parts       = split($version, '[.]')
    $package_version     = "${version_parts[0]}${version_parts[1]}"

    # This way we can easilly switch between osad and rhnsd.
    #include spacewalk::client::osad

    include epel

    if $wipe_reposd {
        file { '/etc/yum.repos.d':
            ensure  => directory,
            recurse => true,
            purge   => true,
            require => Exec['spacewalk_join']
        }
    }

    yumrepo { 'spacewalk-client' :
      enabled => 1,
      descr   => 'Spacewalk Client Repository for EL - $basearch',
      baseurl => $operatingsystemrelease ? {
        /^5/ => 'http://yum.spacewalkproject.org/2.1-client/RHEL/5/$basearch/',
        /^6/ => $spacewalk_client_repo,
        /^7/ => $spacewalk_client_repo,
      },
      gpgkey  => $spacewalk_client_repo_gpg
    }

    package { "rhn-setup" :
        ensure => present,
        require => Yumrepo['spacewalk-client'];
    }

    exec { "spacewalk_join" :
        command => "rhnreg_ks --serverUrl=${server_url} --sslCACert=${ssl_ca_cert} --activationkey=${keys} --profilename=$::fqdn",
        creates => '/etc/sysconfig/rhn/systemid',
        require => Package["rhn-setup"],
    }

    exec { 'initial_yum_clean' :
        command     => 'yum clean all',
        subscribe   => Exec['spacewalk_join'],
        refreshonly => true,
    }

}
