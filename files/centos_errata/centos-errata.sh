#!/bin/bash
# Processes CentOS Errata and imports it into Spacewalk
#

export LC_TIME="en_US.utf8"

. /etc/sysconfig/centos-errata
####
#
# The centos-errata file should contain something like the following
#
#    BASE="/opt/Centos-Errata"
#    VERSION="6"
#
###

. /etc/sysconfig/spacewalk-credentials
####
#
# The spacewalk-credentials file should contain something like the following
#
#    USERNAME="admin"
#    PASSWORD="password"
#
###


/etc/init.d/rhn-search cleanindex

echo "`date` INFO: Populating Errata for CentOS ${VERSION}"

${BASE}/centos-errata.py -c ${BASE}/centos${VERSION}-errata.cfg -f mail-archive.com --login $USERNAME --password $PASSWORD
