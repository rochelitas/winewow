#! /bin/bash
set -e

if [ "z$*" = "z" ]
then
  echo "usage: $0 instname" 1>&2
  exit 1
fi

base=$( dirname $( readlink -f $0 ) )
refname="valkyrie-wow"
instname="vlk_$1"
instdir="$base/$instname"

shift

if [ ! -e "$instdir" ]
then
  echo "$instdir not exists" 1>&2
  exit 1
fi

Prefix="$instname/"
source $base/wine-staging-32.rc
# source $base/wine-sys32.rc

test -L $drive_c/wow || ln -s ../.. $drive_c/wow
# fw $*

cd $drive_c/wow
$wine ./WoW.exe -opengl
