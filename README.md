puppet-spacewalk
================

Create the files

    ###/etc/sysconfig/spacewalk-credentials 
    USERNAME="admin"
    PASSWORD="putyourUIpasshere"


    ###/etc/sysconfig/centos-errata
    BASE="/opt/Centos-Errata"
    VERSION="6"

and simply

    include spacewalk::spacewalk
    include spacewalk::centos_errata
    include spacewalk::proxy



