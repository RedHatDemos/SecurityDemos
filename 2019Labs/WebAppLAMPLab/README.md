```Copy / replace these terms with the server hostnames or IPs that we finalize in the lab:
$workstation
$server01
$server02
```

# STEP1:
__MISSION:__  Install the LAMP web-app, "WordPress" Via Ansible Role
__STEPS:__	Run the job template "LAMP WordPress Deploy" from Ansible Tower, to install the web application for WordPress.  
- This installs the Apache server on $server01 and the DB server on $server02.
- This also installs the hacker tool scripts we're going to use.  They install to $workstation
- To validate install, from your workstation, go to http://$server01


# STEP2:	
__MISSION:__  Confirm we can access the database insecurely
__STEPS:__	Go to the command-line of your machine and connect to the database.  This command will allow you to connect and will prove that the DB has been set up insecurely so that anyone can connect with no password, from any machine, anywhere.

We have a user named "insecure" with no password for his account.  His access is set wide open.  Run this command to confirm you can connect.


```mysql WordPress -h rhel2.example.com -u insecure

Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is something
Server version: 5.5.60-MariaDB MariaDB Server

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [WordPress]>  exit
```

If you see the above dialogue, you're in!  Type "exit" to leave the MySQL prompt and return back to a regular command line.


# STEP3:	
__MISSION:__  Exploit the database vulnerability
__STEPS:__	On your workstation, you'll find a file called `/tmp/cat_meme_takeover.sh` .
- Run this script to exploit the DB.
- If you see this, it was successful:
```
      ##############################
       __  __ _____ _____        __ 
      |  \/  | ____/ _ \ \      / / 
      | |\/| |  _|| | | \ \ /\ / /  
      | |  | | |__| |_| |\ V  V /   
      |_|  |_|_____\___/  \_/\_/    
   	       	       	       	  
      ##############################
                                    
      DONE!  Now reload the web page
         http://rhel1.example.com    
 to see what the evil cat hacker clan did!

```

Now, refresh the page at:  http://rhel1.example.com


# STEP4:	
__MISSION:__  Let's re-install the original WordPress role to reset the servers to a stable baseline.
__STEPS:__	Run the job template again "LAMP WordPress Deploy" from Ansible Tower, to install the web application for WordPress.  
- This installs the Apache server on $server01 and the DB server on $server02.
- This also installs the hacker tool scripts we're going to use.  They install to $workstation
- To validate install, from your workstation, go to http://$server01

Now, refresh the page at:  http://rhel1.example.com

YAYY!  We're no longer victims of a cat meme exploit!

# STEP5:	
__MISSION:__  Let's lock down the database so this won't work again.
__STEPS:__	Run the job template again "LAMP WordPress Secure" this time, from Ansible Tower, to run the hardening playbook.  
- This removes the open vulnerability which allows you to connect to the database and exploit it with cat memes.

Now, refresh the page at:  http://rhel1.example.com
To confirm everything still works


# STEP6:	
__MISSION:__  Confirm we can not access the database insecurely (same steps as step 2)
__STEPS:__	Go to the command-line of your machine and connect to the database.  This command should not allow you to connect now that we've run the playbook to harden our connection.



