class spacewalk::client::setup ( 
    $server_url,
    $keys,
    $version,
    $ssl_ca_cert = '/usr/share/rhn/RHN-ORG-TRUSTED-SSL-CERT',
    $wipe_reposd  = false
    ) {

    $version_parts       = split($version, '[.]')
    $package_version     = "${version_parts[0]}${version_parts[1]}"

    # This way we can easilly switch between osad and rhnsd.
    include spacewalk::client::osad

    include epel

    if $spacewalk::wipe_reposd {
        file { '/etc/yum.repos.d':
            ensure  => directory,
            recurse => true,
            purge   => true,
            require => Exec['spacewalk_join']
        }
    }

    yumrepo { 'SpacewalkClient' :
      enabled => 1,
      descr   => 'Spacewalk Client Repository for EL - $basearch',
      baseurl => $operatingsystemrelease ? {
        /^5/ => 'http://yum.spacewalkproject.org/1.8-client/RHEL/5/$basearch/',
        /^6/ => 'http://yum.spacewalkproject.org/1.8-client/RHEL/6/$basearch/'
      },
      gpgkey  => 'http://yum.spacewalkproject.org/RPM-GPG-KEY-spacewalk-2012'
    }->
    package { "rhn-setup" :
        ensure => present,
        require => Yumrepo['SpacewalkClient'];
    }->
    package { "rhncfg-actions" :
        ensure => present,
        require => Yumrepo['SpacewalkClient'];
    }->
    exec { "spacewalk_join" :
        command => "rhnreg_ks --serverUrl=${server_url} --sslCACert=${ssl_ca_cert} --activationkey=${keys} --profilename=$::fqdn",
        creates => '/etc/sysconfig/rhn/systemid',
        require => Package["rhn-setup"],
    }
}
