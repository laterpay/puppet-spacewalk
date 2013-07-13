class spacewalk::centos_errata::package {

    package {
        'python-lxml':
            ensure  => installed;  
    }

}
