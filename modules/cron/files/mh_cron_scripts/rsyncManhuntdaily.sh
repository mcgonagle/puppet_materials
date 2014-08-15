#!/bin/bash
# $Id: rsyncManhuntdaily.sh,v 1.4 2010/08/03 14:56:39 apradhan Exp $

for i in `seq 2 4`
do
  ( rsync -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" -a --partial --delete-before --force /var/www/html/wordpress-latest/wp-content/blogs.dir/. blogsite0$i:/var/www/html/wordpress-latest/wp-content/blogs.dir )
done


date >> /tmp/rsyncManhuntdaily_runtimes
