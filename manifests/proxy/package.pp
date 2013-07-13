class spacewalk::proxy::package {

    package {
	'spacewalk-proxy-selinux':
            ensure => installed;
	'spacewalk-proxy-installer':
            ensure => installed;
    }

}
