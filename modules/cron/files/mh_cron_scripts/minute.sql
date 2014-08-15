DELETE FROM manhunt_jp.Sessions WHERE lastAccess <  NOW() - INTERVAL 40 MINUTE and uid!=0;
