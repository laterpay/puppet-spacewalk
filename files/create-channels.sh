#!/bin/bash
## This script will create spacewalk channels
 
## global variables
SCRIPT=`basename $0`
DEBUG=false
 

. /etc/sysconfig/spacewalk-credentials

####
#
# The spacewalk-credentials file should contain something like the following
#
#    USERNAME="admin"
#    PASSWORD="password"
#
###


## script specific variables
#default spacewalk
SWVERSION=$(rpm -q spacewalk-repo --queryformat '%{VERSION}')
# default arch
ARCH="x86_64"
# default distro
DISTRO="centos"
## end script specific variables
 
if [ $DEBUG == true ]
then
  set -x
fi
 
# display help
function showhelp() {
  echo "usage: ${SCRIPT} -r <release> [-a <architecture>] [-d <distro>] [-s <spacewalk_version>]"
  echo "example: ${SCRIPT} -r 6.4 -a x86_64"
  exit 1
}
 
# parse options - these can override defaults
while getopts "r:a:d:s:h" opt; do
  case $opt in
    r)
    RELEASE=$OPTARG
    ;;
    a)
    ARCH=$OPTARG
    ;;
    d)
    DISTRO=$OPTARG
    ;;
    s)
    SWVERSION=$OPTARG
    ;;
    h)
    showhelp
    ;;
    \?)
    echo "Invalid option: -$OPTARG" >&2
    ;;
    :)
    echo "Option -$OPARG requires and argument." >&2
    showhelp
    ;;
  esac
done
 
# if there is no release set - then display help
if [[ -z $RELEASE ]]
then
showhelp
fi
 
MAINRELEASE=`echo $RELEASE| cut -d . -f1`
SHORTSWVERSION=${SWVERSION//.}
 
spacewalk-common-channels -u $USERNAME -p $PASSWORD -a $ARCH -k unlimited "${DISTRO}${MAINRELEASE}*" "epel*" "spacewalk${SHORTSWVERSION}*"
spacewalk-common-channels -u $USERNAME -p $PASSWORD -a $ARCH -k unlimited -c base_channels.ini '*'
spacewalk-remove-channel  --list

exit 0
