#!/usr/bin/python

import datetime
import time
import MySQLdb
from os import environ

def main(msgdb):
	updated=0
	cursor1 = msgdb.cursor()
	getTables="show tables like 'Inbox_%'"
	cursor1.execute(getTables)
	inboxes = cursor1.fetchall()
	for result in inboxes:
		inbox=str(result).split(",")
		inbox=str(inbox[0:1])[4:-3]
		getUids = "select distinct toUid from " + inbox + " where toUid>0"
		print "total updated",updated
		print datetime.datetime.now()
		print inbox
		cursor1.execute(getUids)
		uids=cursor1.fetchall()
		for uid in uids:
			uid=str(uid).split(",")
			uid=str(uid[0:1])[3:-3]
			new=update_user(uid,cursor1,inbox[-2:])
			updated=updated+new
#		time.sleep(10)
	msgdb.close()


def getMsgCounts(id,cursor):
	count=""
	getMessageTotals="select uid,totalMsgs,unreadMsgs,totalSent,unreadSent,totalSaved from MessageTotals where uid="+str(id)
	getcounts="select uid,totalMsgs,unreadMsgs,totalSent,unreadSent,totalSaved from counts where uid="+str(id)
	cursor.execute(getcounts)
	result=cursor.fetchone()
	if result:
		count=count+"counts	"
		for (name, value) in zip(cursor.description, result):
			count=count+ str(name[0])+"="+str(value)+"	 "
		count=count+"\nMT "
		cursor.execute(getMessageTotals)
		result=cursor.fetchone()
		for (name, value) in zip(cursor.description, result):
			count=count+ str(name[0])+"="+str(value)+"	 "
		count=count+"\n"
	return count

def update_user(id,cursor,mailbox):
	numupdated=0
	before=getMsgCounts(id,cursor)
	id=str(id)
	updatetotal="update counts set totalMsgs=(select count(*) from Inbox_" + mailbox + " where toUid="+id+") where uid="+id
	rows1=cursor.execute(updatetotal)
	updatesent="update counts set totalSent=(select count(*) from Sent_" + mailbox + " where fromUid="+id+") where uid="+id
	rows2=cursor.execute(updatesent)
	updateusent="update counts set unreadSent=(select count(*) from Sent_" + mailbox + " where fromUid="+id+" and seen=0) where uid="+id
	rows3=cursor.execute(updateusent)
	updateuinbox="update counts set unreadMsgs=(select count(*) from Inbox_" + mailbox + " where toUid="+id+" and seen=0) where uid="+id
	rows4=cursor.execute(updateuinbox)
	updatesaved="update counts set totalSaved=(select count(*) from Saved_" + mailbox + " where toUid="+id+") where uid="+id
	rows5=cursor.execute(updatesaved)
	fixMT="INSERT INTO MessageTotals (uid,totalMsgs,unreadMsgs,totalSent,unreadSent,totalSaved) SELECT uid,totalMsgs,unreadMsgs,totalSent,unreadSent,totalSaved FROM counts WHERE uid="+id+" ON DUPLICATE KEY UPDATE totalMsgs=VALUES(totalMsgs),unreadMsgs=VALUES(unreadMsgs),totalSent=VALUES(totalSent),unreadSent=VALUES(unreadSent),totalSaved=VALUES(totalSaved)"
	rows6=cursor.execute(fixMT)
	total=rows1+rows2+rows3+rows4+rows5
	if total>0:
		numupdated=numupdated+1
#		after=getMsgCounts(id,cursor)
#		print str(total)+" rows changed"
#		print before
#		print after
	return numupdated

msgdb1 = MySQLdb.connect(host="192.168.1.212",user="apache",passwd="LQSyM",db="messages")
main(msgdb1)
msgdb2 = MySQLdb.connect(host="192.168.1.201",user="apache",passwd="LQSyM",db="messages")
main(msgdb2)
