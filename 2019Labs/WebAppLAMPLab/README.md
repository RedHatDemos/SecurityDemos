# Lab Excercises Overview
This lab demonstrates how installing a simple web application can leave open exploits.  In some instances, a default mysql / mariadb installation includes default users that are allowed to connect without a password set.  And if not at the time of installation, humans will often open up liberal permissions to make testing easier during development.  When these changes make their way into production, a site is left vulnerable to attackers who are looking for these loopholes.

We will demonstrate this vulnerability with some simple commands.  After using an Ansible playbook to install a base WordPress web site, you will run a small shell script from your workstation, which will take over the public-facing corporate site with cat memes.  We will then use an Ansible playbook to search and remediate common vulnerabilities (in this case, accounts with liberal permissions and no password set).  After remediating the problem, we will see that our exploit script no longer works.


# TASK1:
__MISSION:__  Install the LAMP web-app, "WordPress" Via Ansible Role

__STEPS:__  Run the job template "LAMP WordPress Deploy" from Ansible Tower, to install the web application for WordPress.  

- This role is configured to run against three servers in a group called *lampservers* :

| lampweb | lampdb | lampjump |
| :----------------------: | :----------------------: | :----------------------: |
| This server is used for the apache web server.  There is no local database on this machine | this server is a standalone database with no other purpose than to hose the MySQL / MariaDB. | This is a "jump box," representing a machine that a hacker might use to connect and run some scripts in order to exploit your new web site. |
| The wordpress application is set with a default login of: `admin` with a password of `Password123`. | The database has been configured correctly to the WordPress application.  However, we made a major mistake here and left one account unsecured.  It's possibly (and sometimes default) to have a database configured to allow traffic from ANYWHERE with NO PASSWORD REQUIRED!!!!  | You will log in as lab-user to this machine and see a script in your home directory.  Additionally, you can run remote MySQL commands from this machine against the unsecured database. |
 
- This role appears to install an innocent apache server on one and a db on the other.  To the innocent eye, we complete this step and validate by visiting the website... everything looks clean and safe!
- Once ths role is run, you can confirm the application has been installed by using a web browser to go to http://rhel1.example.com


# TASK2:	
__MISSION:__  Confirm we can access the database insecurely and mess with the user accouts that already exist on the box.  This effectively will lock out the legitimate user of the WordPress site so that they can no longer log in... but you will now have admin access to the site!

__STEPS:__	Go to the command-line of your jumpbox machine.  SSH in as *lab-user@rhel3.example.com* and connect to the database.  This command will allow you to connect and will prove that the DB has been set up insecurely so that anyone can connect with no password, from any machine, anywhere.

We have a user named "insecure" with no password for his account.  His access is set wide open.  Run this command to confirm you can connect.

```mysql WordPress -h rhel2.example.com -u insecure```
<pre>

Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is something
Server version: 5.5.60-MariaDB MariaDB Server

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [WordPress]>  exit
</pre>

If you see the above dialogue, you're in!  And that's really really bad.

<img src="https://raw.githubusercontent.com/RedHatDemos/SecurityDemos/master/2019Labs/WebAppLAMPLab/roles/wordpress-server/templates/twentyseventeen-catsploit/assets/images/cat-hack01.jpg" width="150">

Okay, so that's not good.  No really, that's not good at all.  Anyone with a bit of curiosity can directly access the database that runs your entire site!  They could add their own users and just sit back and wait... and when you run for public office, they could start posting bad things about you on YOUR OWN WEBSITE!  Or they could just go for the gusto right now and cover your site in cat memes.  Yeah.  That's the one.  In the next step, that's exactly what we're going to look at.  But first, let's make ourselves a WordPress user so we can go in anytime and post articles.

- While we're in the MySQL database, let's take a look at the users who are allowed to log in to the WordPress server:

```select user_login,user_pass from wp_users;```

```select * from wp_usermeta WHERE meta_key = 'wp_capabilities';```

We see the user and the password has that's stored in the database for this user, as well as data that defines the access level.  Now we're at a moral crossroads.  Do we notify the owner of the site to warn them of this vulnerability?  The fact that we can access the site's database and make changes without any credentials?  Ideally yes.  And I'm proud of you for that thought.  But in this case, we want to demonstrate how bad this could be.  So in this lab, we're going to do the wrong thing and take advantage of this inappropriate level of access.  The access level for this user (level 10, being an administrative user) is stored in a second table.  We can view this info direct from the databse and change it if we like:

<pre>
MariaDB [WordPress]> select user_login,user_pass,user_nicename from wp_users;
+------------+----------------------------------+---------------+
| user_login | user_pass                        | user_nicename |
+------------+----------------------------------+---------------+
| admin      | 42f749ade7f9e195bf475f37a44cafcb | admin         |
+------------+----------------------------------+---------------+
1 row in set (0.00 sec)

MariaDB [WordPress]> select * from wp_usermeta WHERE meta_key = 'wp_capabilities';
+----------+---------+-----------------+---------------------------------+
| umeta_id | user_id | meta_key        | meta_value                      |
+----------+---------+-----------------+---------------------------------+
|       11 |       1 | wp_capabilities | a:1:{s:13:"administrator";b:1;} |
+----------+---------+-----------------+---------------------------------+
1 row in set (0.00 sec)


MariaDB [WordPress]> 

</pre>

From here... we could change the admin password so that we can always log in as "admin" with our new password.  Chances are, someone will realize they're locked out and eventually get back in.  A real-world example would actually be sneaker:  if we were the type of user to do such a thing as this, we would probably create an ambiguous username that *looked* official but was our secret access backdoor.

## The easy way
- it's as simple as updating the admin user's password.  We don't know what that password even is, so we can't log in to WordPress conole... but we have wide open database access!  So we can set it to whatever we want!

- run this command to change the wordpress admin user's password:

```update wp_users set  user_pass=MD5('FluffyBunny') WHERE `user_login`='admin';```

- The admin user for this WordPress instance is now set to:
  * login: `admin`
  * password:  `FluffyBunny`

- Verify you have access by visiting this admin login URL and logging in with your new credentials.
  * http://rhel1.example.com/wp-admin/

WOW.  We are in!  Verify by logging in as our admin account.  The main thing we're pointing out here is the fact that 


- For now, get out of the MySQL prompt...
- Type "exit" to leave the MySQL prompt and return back to a regular command line.




# TASK3:	
__PREAMBLE:__ First of all, what we are about to do here is a very very not nice thing.  But it's important to see that this is the type of event that happens all the time when people miss even one simple security vulnerability.  Do not try this at home... or at the library... or from a computer anywhere.  Always be nice and polite online.  But for just one moment, we're going to do something rotten in this lab.

__MISSION:__  Exploit the database vulnerability

__STEPS:__	On your workstation, you'll find a file called:

 `/home/lab-user/cat_meme_takeover.sh` 

- Run this script to exploit the DB.
- You will see this after it runs:
```
[lab-user@workstation-repl ~]$ /home/lab-user/cat_meme_takeover.sh

      HACKED!!!  YOU ARE A BAD KITTY!

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


# TASK4:	
__MISSION:__  Let's re-install the original WordPress role to reset the servers to a stable baseline.
__STEPS:__	Run the job template again "LAMP WordPress Deploy" from Ansible Tower, to install the web application for WordPress.  
- This installs the Apache server rhel1.example.com and the DB server on rhel2.example.com
- This also installs the hacker tool scripts we're going to use.  They install to $workstation
- To validate install, from your workstation, go to http://rhel1.example.com

Now, refresh the page at:  http://rhel1.example.com

YAYY!  We're no longer victims of a cat meme exploit!

# TASK5:	
__MISSION:__  Let's lock down the database so this won't work again.
__STEPS:__	Run the job template again "LAMP WordPress Secure" this time, from Ansible Tower, to run the hardening playbook.  
- This removes the open vulnerability which allows you to connect to the database and exploit it with cat memes.

Now, refresh the page at:  http://rhel1.example.com
To confirm everything still works


# TASK6:	
__MISSION:__  Confirm we can not access the database insecurely (same steps as step 2)
__STEPS:__	We have removed our user named "insecure" with no password for his account.  His access was set wide open, but has been revoked with our latest hardening playbook.  Run this command to confirm you can no longer connect.  This is the exact command from TASK2 where we successfully connected

__STEPS:__	We will manually connect to the database from the workstation, as well as attempt to run the exploit again.
- On your workstation, run the same script from the earlier called

 `/home/lab-user/cat_meme_takeover.sh` 

- This time, it should fail with a different message like this:
```
[lab-user@workstation-repl ~]$ /home/lab-user/cat_meme_takeover.sh

        FAILED!  You do not can haz
        permissionz to the database

       ############################## 
       ____      ___        ______  _ 
      |  _ \    / \ \      / /  _ \| |
      | |_) |  / _ \ \ /\ / /| |_) | |
      |  _ <  / ___ \ V  V / |  _ <|_|
      |_| \_\/_/   \_\_/\_/  |_| \_(_)
   	       	       	       	    
       ############################## 
                                      
        FAILED!  You do not can haz   
        permissionz to the database   
```
- We also want to confirm the database access has been locked down by running this command from the command line of our lab workstation:

```mysql WordPress -h rhel2.example.com -u insecure```

ACCESS DENIED!



