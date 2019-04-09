## This insert will make the MySQL (mariadb) server accept connections from anywhere... bad bad bad
##   mysql -h {{ dbhostname }} mysql < 01_db-wide-open.sql

INSERT INTO `user` VALUES ('%','root','','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','','','','',0,0,0,0,'','');

## Then follow with a command:   mysqladmin reload
