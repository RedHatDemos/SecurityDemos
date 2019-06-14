# SELinux

## Expected functionality

Essentially provide mechanisms to manage local customizations:

* Set enforcing/permissive
* restorecon portions of filesystem tree
* Set/Get Booleans
* Set/Get file contexts
* Manage logins
* Manage ports

## Available modules in Ansible

[selinux](http://docs.ansible.com/ansible/selinux_module.html): Configures the
SELinux mode and policy.

[seboolean](http://docs.ansible.com/ansible/seboolean_module.html): Toggles SELinux booleans.

[sefcontext](http://docs.ansible.com/ansible/sefcontext_module.html): Manages
SELinux file context mapping definitions Similar to the `semanage fcontext`
command.

[seport](http://docs.ansible.com/ansible/seport_module.html): Manages SELinux
network port type definitions.

### Modules provided by this repository

selogin: Manages linux user to SELinux user mapping

## Usage

The general usage is demonstrated in [selinux-playbook.yml](selinux-playbook.yml) playbook.

### selinux role

This role can be configured using variables as it is described below.

```yaml
vars:
  [ see below ]
roles:
  - role: linux-system-roles.selinux
    become: true
```

#### purge local modifications

By default, the modifications specified in `selinux_booleans`, `selinux_fcontexts`,
`selinux_ports` and `selinux_logins` are applied on top of pre-existing modifications.
To purge local modifications prior to setting new ones, set following variables to true:

- SELinux booleans: `selinux_booleans_purge`
- SELinux file contexts: `selinux_fcontexts_purge`
- SELinux ports: `selinux_ports_purge`
- SELinux user mapping: `selinux_logins_purge`

You can purge all modifications by using shorthand:

```yaml
selinux_all_purge: true
```

#### set SELinux policy type and mode

```yaml
selinux_policy: targeted
selinux_state: enforcing
```
Allowed values for `selinux_state` are `disabled`, `enforcing` and `permissive`.

If `selinux_state` is not set, the SELinux state is not changed.
If `selinux_policy` is not set and SELinux is to be enabled, it defaults to `targeted`. 
If SELinux is already enabled, the policy is not changed.

#### set SELinux booleans

```yaml
selinux_booleans:
  - { name: 'samba_enable_home_dirs', state: 'on' }
  - { name: 'ssh_sysadm_login', state: 'on', persistent: 'yes' }
```

#### Set SELinux file contexts

```yaml
selinux_fcontexts:
  - { target: '/tmp/test_dir(/.*)?', setype: 'user_home_dir_t', ftype: 'd', state: 'present' }
```

Individual modifications can be dropped by setting `state` to `absent`.

#### Set SELinux ports

```yaml
selinux_ports:
  - { ports: '22100', proto: 'tcp', setype: 'ssh_port_t', state: 'present' }
```

#### run restorecon on filesystem trees

```yaml
selinux_restore_dirs:
  - /tmp/test_dir
```

#### Set linux user to SELinux user mapping

```yaml
    selinux_logins:
      - { login: 'plautrba', seuser: 'staff_u', state: 'absent' }
      - { login: '__default__', seuser: 'staff_u', serange: 's0-s0:c0.c1023', state: 'present' }
```

## Ansible Facts

### selinux\_reboot\_required

This custom fact is set to `true` if system reboot is necessary when SELinux is set from `disabled` to `enabled` or vice versa.  Otherwise the fact is set to `false`.  In the case that system reboot is needed, it will be indicated by returning failure from the role which needs to be handled using a `block:`...`rescue:` construct. The reboot needs to be performed in the playbook, the role itself never reboots the managed host. After the reboot the role needs to be reapplied to finish the changes.
