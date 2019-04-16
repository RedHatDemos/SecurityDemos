[![GoKEV](http://GoKEV.com/GoKEV200.png)](http://GoKEV.com/)

<div style="position: absolute; top: 40px; left: 200px;">

# GoKEV-dummy-role

This project is a dummy role that simply echoes back a variable you give it.  The purpose for this is to easily demonstrate workflow concepts without building a working playbook or role to do so.

Within Ansible Tower, you can launch the playbook found here:  https://github.com/GoKEV/GoKEV-dummy-playbook.git

## Here's an example of how you could launch this role:
<pre>
ansible-playbook GoKEV-dummy-role.yml
</pre>

## Example Playbook called GoKEV-dummy-role.yml:

<pre>
---
- name: Run this dummy role
  hosts: localhost
  gather_facts: no

  vars:
    dummy_message: You can override this dummy_message variable with extra vars if you like.

  roles:
    - GoKEV.dummy-role

</pre>

## With a requirements.yml that looks as such:

<pre>
---
- name: GoKEV.dummy-role
  version: master
  src: https://github.com/GoKEV/GoKEV-dummy-role.git

</pre>

## Troubleshooting & Improvements

- Not enough testing yet

## Notes

  - Not enough testing yet

## Author

This project was created in 2018 by [Kevin Holmes](http://GoKEV.com/).

