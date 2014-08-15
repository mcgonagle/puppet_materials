#!/bin/sh
# $Id: lvsnap.sh,v 1.3 2008/06/30 17:57:28 rbraun Exp $
#
# lvsnap.sh
#
# Created 6/08 by rbraun
#   Invoke this from cron to rotate and create LVM snapshots.  Parameters:
#     $1  logical volume name e.g. volroot
#     $2  snapshot name, e.g. hourly or daily
#     $3  snapshot size
#     $4  number of snapshots to keep (similar to logrotate)
#
#   If a file restore is needed, simply mount the desired snapshot as in:
#
#     mount /dev/mapper/system-snap.volroot.hourly.1 /mnt
#
#   Don't forget to dismount the snapshot when done (this script will stop
#   rotating until you do)

#. /etc/manhunt/source.sh

# Run as root
if [ "$UID" -ne 0 ]
then
 echo "Must be root to run this script."
  exit $ERROR
fi  

LV=$1
SNAPNAME=$2
SNAPSIZE=$3
SNAPNUM=$4
VG=system

PATH=/bin:/usr/bin:/sbin:/usr/sbin

# Delete oldest
[ -e          /dev/$VG/snap.$LV.$SNAPNAME.$SNAPNUM ] && \
  lvremove -f /dev/$VG/snap.$LV.$SNAPNAME.$SNAPNUM >/dev/null

# Rotate numbered snapshots down e.g. 3->4, 2->3, 1->2

I=$SNAPNUM
J=$[I-1]
while [ $I -gt 1 ]
do
  [ -e /dev/$VG/snap.$LV.$SNAPNAME.$J ] && \
      lvrename /dev/$VG/snap.$LV.$SNAPNAME.$J /dev/$VG/snap.$LV.$SNAPNAME.$I >/dev/null
  I=$J
  J=$[I-1]
done

# Create new with suffix .1

lvcreate --snapshot --size=$SNAPSIZE --name=snap.$LV.$SNAPNAME.1 /dev/$VG/$LV >/dev/null
