#! /bin/bash
set -e

if [ "z$*" = "z" ]
then
  echo "usage: $0 instname" 1>&2
  exit 1
fi

base=$( dirname $( readlink -f $0 ) )
iname="$1"
refname="valkyrie-wow"
instname="vlk_$iname"
refdir="$base/$refname"
instdir="$base/$instname"

if [ ! -d "$refdir" ]
then
  echo "reference directory $refdir not found or not a directory" 1>&2
  exit 1
fi

if [ -e "$instdir" ]
then
  echo "$instdir already exists" 1>&2
  exit 1
fi

echo "* create nistance container"
mkdir -p $instdir

echo "* create link to datafiles"
cd $refdir
for name in Data Documentation Fonts WoW.exe *.dll
do
  find $name -depth -type f -print |
  while read L 
  do
#    echo "process '$L' ..."
    d=$(dirname $L)
    if [ "$d" = "." ]; then
      ln -s ../$refname/$L $instdir/
    else
      mkdir -p $instdir/$d
      p=$(echo "$d" | sed -e 's#[^/]\+#..#g')
      ln -s ../$p/$refname/$L $instdir/$d/
    fi
  done 
done

echo "* copy non-linked datafiles"
cp $refdir/realmlist.wtf $instdir
mkdir $instdir/WTF
cp $refdir/WTF/Config.wtf $instdir/WTF
cp -r $refdir/Interface $instdir

echo "* create launcher"
launcher="$base/vlk_run_$iname.sh"
cat >$launcher <<_EOF_
#! /bin/bash
exec \$(dirname \$(readlink -f \$0) )/vlk_run.sh $iname
_EOF_
chmod +x $launcher

echo "valkyrie instance $iname created"

