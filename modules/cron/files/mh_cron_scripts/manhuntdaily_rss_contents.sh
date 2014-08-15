#!/bin/bash

. /etc/manhunt/source.sh
LOG=$CARE_LOG
CONTENTS_PHP="/mnt/manhunt/other/common/blog/contents.php"

# Run as care.
if [ "$UID" -ne "$CARE_UID" ]
then
  echo "Must be care to run this script."
  exit $ERROR
fi


if [ "`touch $LOG`" != "" ]
then
 echo "Cannot write to logfile."
 exit $ERROR
fi


FIRST_ITEM=$(lynx -dump http://www.manhuntdaily.com/rss.xml|grep -n "<item>"|head -1|cut -f1 -d:)
FIRST_ITEM_CLOSE=$(lynx -dump http://www.manhuntdaily.com/rss.xml|grep -n "</item>"|head -1|cut -f1 -d:)

if [ -z $FIRST_ITEM ] || [ -z $FIRST_ITEM_CLOSE ]; then
 echo no first item $FIRST_ITEM or no first item close $FIRST_ITEM_CLOSE exiting... >> $LOG
 exit 1
fi

BLOG_DESCRIPTION=$(lynx -dump http://www.manhuntdaily.com/rss.xml| sed -n "${FIRST_ITEM},${FIRST_ITEM_CLOSE}p"|sed -n '/<description>/p'|sed 's#<description>##g'|sed 's#</description>##g')
BLOG_LINK=$(lynx -dump http://www.manhuntdaily.com/rss.xml| sed -n "${FIRST_ITEM},${FIRST_ITEM_CLOSE}p"|sed -n '/<link>/p'|sed 's#<link>##g'|sed 's#</link>##g')

if [ -z $BLOG_DESCRIPTION ||  -z $BLOG_LINK ]; then
 echo no blog description $BLOG_DESCRIPTION or no blog link $BLOG_LINK exiting... >> $LOG
 exit 1
fi

if [ -w $CONTENTS_PHP ]; then
#Output data to the log first then output it to the contents.php file that is
#sourced by Timmys code
`date` >> $LOG
(
cat <<HERE
<?php
\$blog_article = "${BLOG_DESCRIPTION}";
\$blog_link = "${BLOG_LINK}";

HERE
) >> $LOG
`date` >> $LOG
#Outputs the rss content to the contents.php file
(
cat <<HERE
<?php
\$blog_article = "${BLOG_DESCRIPTION}";
\$blog_link = "${BLOG_LINK}";

HERE
) > $CONTENTS_PHP
chmod 666 $CONTENTS_PHP

else 
 `date` >> $LOG
 echo Could not write to the ${CONTENTS_PHP} file >> $LOG
 exit 1
fi 

