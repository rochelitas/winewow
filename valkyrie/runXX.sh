#! /bin/bash
set -e

base=$( dirname $( readlink -f $0 ) )
name=$(basename $0 .sh)


cd $base

case "$name" in
*64)
  echo "use 64-bit wine"
  source wine-staging-64.rc
  ;;
*32)
  echo "use 32-bit wine"
  source wine-staging-32.rc
  ;;
*)
  echo "UNKNOWN BITNESS from name \"$name\"" 1>&2
  exit 1
  ;;
esac

echo "WINEPREFIX=$WINEPREFIX"
echo "DRIVE_C=$drive_c"

