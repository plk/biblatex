#!/usr/bin/env bash

if [ ! -e build/build.sh ]
then
  echo "Please run in the root of the distribution tree" 1>&2
  exit 1
fi

declare TAG_VERSION=`git describe --tags | cut -d '-' -f 1`
declare DATE=`date '+%Y/%m/%d'`

\rm -rf tds/*
cp -r bibtex build/tds/
cp -r doc build/tds/
cp -r tex build/tds/

find tds -type f | xargs perl -pi.bak -e "s/\$Id:\$/\$Id: $DATE $VERSION \$/;"




