#!/bin/bash

SOURCE=~/srfi/split
DESTINATION=/var/www/srfi
cd $DESTINATION/
find . -mindepth 1 -delete
for DIR in common email
  do
  echo $DIR
  ((cd $SOURCE/srfi-$DIR && git archive --format=tgz HEAD)|tar xzf -)
done
$SOURCE/srfi-common/admin/link-to-new-archives.sh
for I in $(seq 0 121)
  do
  echo srfi-$I
  (cd $SOURCE/srfi-$I && git archive --format=tgz HEAD)|(cd $DESTINATION/srfi-$I; tar xzf -)
done
cp -p $DESTINATION/README.html $DESTINATION/index.html
chmod -R 0755 $DESTINATION