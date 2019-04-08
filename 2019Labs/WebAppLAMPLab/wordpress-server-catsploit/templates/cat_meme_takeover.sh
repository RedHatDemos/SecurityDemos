#!/bin/sh

mysql -u root {{ wpdbname }} < /tmp/cat_meme_takeover.sql

echo
echo
echo '      ##############################'
echo '       __  __ _____ _____        __ '
echo '      |  \/  | ____/ _ \ \      / / '
echo '      | |\/| |  _|| | | \ \ /\ / /  '
echo '      | |  | | |__| |_| |\ V  V /   '
echo '      |_|  |_|_____\___/  \_/\_/    '
echo '   	       	       	       	  '
echo '      ##############################'
echo '                                    '
echo '      DONE!  Now reload the web page'
echo '         http://{{ myhostname }}    '
echo ' to see what the evil cat hacker clan did!'
echo
echo

