#!/usr/bin/env bash

declare TAG_VERSION=`git describe --tags | cut -d '-' -f 1`
declare DATE=`date '+%Y/%m/%d'`

find . -type f | xargs perl -pi.bak -e "s/\$Id:\$/\$Id: $DATE $VERSION \$/;"




