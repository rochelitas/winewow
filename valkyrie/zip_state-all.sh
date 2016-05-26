#! /bin/bash

base=$(dirname $(readlink -f $0))
cd $base

find . -depth -maxdepth 2 -type f -name zip_state.sh -exec \{\} \;
