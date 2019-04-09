<pre>Copy / replace these terms with the server hostnames or IPs that we finalize in the lab:

$workstation
$server01
$server02
</pre>





#STEP1:	Run the job template "LAMP WordPress Deploy" to install the web application for WordPress.  
##	This installs the Apache server on $server01 and the DB server on $server02.
##	This also installs the hacker tool scripts we're going to use.  They install to $workstation
##	To validate install, from your workstation, go to http://$server01


#TASK2:	
##	MISSION:  Confirm we can access the database insecurely
##	STEPS:	Go to the command-line of your machine and connect to the database.  This command will allow you to connect and will prove that the DB has been set up insecurely so that anyone can connect with no password, from any machine, anywhere.

##	We have a user named "insecure" with no password for his account.  His access is set wide open.  Run this command to confirm you can connect.


```mysql WordPress -h rhel2.example.com -u insecure

Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is something
Server version: 5.5.60-MariaDB MariaDB Server

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [WordPress]> ```

##	If you see the above dialogue, you're in!  Type "exit" to leave the MySQL prompt and return back to a regular command line.





