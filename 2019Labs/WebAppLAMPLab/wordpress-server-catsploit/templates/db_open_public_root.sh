#!/bin/sh

/bin/mysql -u root mysql < /tmp/db_open_public_root.sql
/bin/mysqladmin -u root reload

echo DONE!  Now try this from the command line of another machine:
echo mysql -h {{ myhostname }} -u root
echo
echo You should be able to connect to the database!
