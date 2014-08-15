use manhunt;
CREATE TABLE `NetLoginHistoryTemp` (
  `login` datetime NOT NULL default '0000-00-00 00:00:00',
  `uid` int(10) unsigned NOT NULL default '0',
  `logout` datetime default NULL,
  `logoutReason` varchar(10) default NULL,
  `state_code` varchar(5) NOT NULL default '',
  PRIMARY KEY  (`uid`,`login`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

INSERT INTO NetLoginHistoryTemp (login,uid,logout,logoutReason,state_code) SELECT login,uid,logout,logoutReason,state_code FROM NetLoginHistory WHERE logout IS NULL;

TRUNCATE NetLoginHistory;

INSERT INTO NetLoginHistory (login,uid,logout,logoutReason,state_code) SELECT login,uid,logout,logoutReason,state_code FROM NetLoginHistoryTemp;

DROP TABLE NetLoginHistoryTemp;
