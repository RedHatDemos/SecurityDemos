800-53
=========

This role endeavors to apply relevant NIST 800-53 controls to an Enterprise Linux host.

This is not a "scanner" per-se.  If you wish to assess the application of this role to your host, check out the SCAP Security Guide and Open SCAP projects.  Both of these will provide you tools with which you can scan your host.

All tasks are tagged with the applicable controls.  To see which tasks are related to the "access control" category in the NIST 800-53 controls, execute the following.

```bash
$ ansible-playbook -i [inventory] --tags "AC" --list-tasks [playbook.yml]
```

Requirements
------------

Per 800-53 Audit and Accountability requirements, you are recommended to have the following partitions:

1. `/var`
2. `/var/log`
3. `/var/log/audit`
4. `/home`
5. `/tmp`

These scripts will not create these partitions for you.

**NOTE:** This will make sweeping changes to your host.  It is recommended you apply this role to a freshly provisioned host.

Role Variables
--------------
```yaml
---
# vars file for 800-53

#The schedule for AIDE
aide_minute: 05
aide_hour: 03
aide_day_of_month: '*'
aide_month: '*'
aide_day_of_week: '*'

vpn_package: openswan
#Whether or not to run an SCAP scan
run_scap: true
#The profile to run
scap_profile:
  - stig-rhel{{ ansible_distribution_major_version }}-server-upstream
#Where on your local host you wish to place the reports
scap_reports_dir: /tmp
```
Dependencies
------------

ansible 2.2.0.0

Example Playbook
----------------

```yaml
# file: 80053.yaml
---
- hosts: 80053_hosts
  become: yes
  vars:
    scap_reports_dir: ~/scap_reports
  roles:
    - ansible-role-800-53
```
Example Inventory
-----------------
```ini
[80053_hosts]
172.16.78.159
```
Example Run
-----------
```bash
ansible-playbook -u admin -i 80053_inventory 80053.yaml
```

License
-------

Apache 2.0

Author Information
------------------

Ken Evensen is a Solutions Architect with Red Hat
