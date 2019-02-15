#!/usr/bin/python

# (c) 2017, Petr Lautrbach <plautrba@redhat.com>
# Based on seport.py module (c) 2014, Dan Keder <dan.keder@gmail.com>

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

ANSIBLE_METADATA = {'status': ['preview'],
                    'supported_by': 'community',
                    'version': '1.0'}

DOCUMENTATION = '''
---
module: selogin
short_description: Manages linux user to SELinux user mapping
description:
     - Manages linux user to SELinux user mapping
version_added: "1.0"
options:
  login:
    description:
      - a Linux user
    required: true
    default: __default__
  seuser:
    description:
      - SELinux user name
    required: true
    default: null
  serange:
    description:
      - MLS/MCS Security Range (MLS/MCS Systems only) SELinux Range for SELinux login mapping  defaults to the SELinux user record range.
    required: false
    default: s0
  state:
    description:
      - Desired mapping value.
    required: true
    default: present
    choices: [ 'present', 'absent' ]
  reload:
    description:
      - Reload SELinux policy after commit.
    required: false
    default: yes
notes:
   - The changes are persistent across reboots
   - Not tested on any debian based system
requirements: [ 'libselinux-python', 'policycoreutils-python' ]
author: Dan Keder
author: Petr Lautrbach
'''

EXAMPLES = '''
# Modify the default user on the system to the guest_u user
- selogin:
    login: __default__
    seuser: guest_u
    state: present

# Assign gijoe user on an MLS machine a range and to the staff_u user
- selogin:
    login: gijoe
    seuser: staff_u
    serange: SystemLow-Secre
    state: present

# Assign all users in the engineering group to the staff_u user
- selogin:
    login: %engineering
    seuser: staff_u
    state: present
'''

try:
    import selinux
    HAVE_SELINUX=True
except ImportError:
    HAVE_SELINUX=False

try:
    import seobject
    HAVE_SEOBJECT=True
except ImportError:
    HAVE_SEOBJECT=False

from ansible.module_utils.basic import *
from ansible.module_utils.pycompat24 import get_exception


def semanage_port_get_ports(seport, setype, proto):
    """ Get the list of ports that have the specified type definition.

    :param seport: Instance of seobject.portRecords

    :type setype: str
    :param setype: SELinux type.

    :type proto: str
    :param proto: Protocol ('tcp' or 'udp')

    :rtype: list
    :return: List of ports that have the specified SELinux type.
    """
    records = seport.get_all_by_type()
    if (setype, proto) in records:
        return records[(setype, proto)]
    else:
        return []


def semanage_port_get_type(seport, port, proto):
    """ Get the SELinux type of the specified port.

    :param seport: Instance of seobject.portRecords

    :type port: str
    :param port: Port or port range (example: "8080", "8080-9090")

    :type proto: str
    :param proto: Protocol ('tcp' or 'udp')

    :rtype: tuple
    :return: Tuple containing the SELinux type and MLS/MCS level, or None if not found.
    """
    ports = port.split('-', 1)
    if len(ports) == 1:
        ports.extend(ports)
    key = (int(ports[0]), int(ports[1]), proto)

    records = seport.get_all()
    if key in records:
        return records[key]
    else:
        return None


def semanage_login_add(module, login, seuser, do_reload, serange='s0', sestore=''):
    """ Add linux user to SELinux user mapping

    :type module: AnsibleModule
    :param module: Ansible module

    :type login: str
    :param login: a Linux User or a Linux group if it begins with %

    :type seuser: str
    :param proto: An SELinux user ('__default__', 'unconfined_u', 'staff_u', ...), see 'semanage login -l'

    :type serange: str
    :param serange: SELinux MLS/MCS range (defaults to 's0')

    :type do_reload: bool
    :param do_reload: Whether to reload SELinux policy after commit

    :type sestore: str
    :param sestore: SELinux store

    :rtype: bool
    :return: True if the policy was changed, otherwise False
    """
    try:
        selogin = seobject.loginRecords(sestore)
        selogin.set_reload(do_reload)
        change = False
        all_logins = selogin.get_all()
        # module.fail_json(msg="%s: %s %s" % (all_logins, login, sestore))
        # for local_login in all_logins:
        if login not in all_logins.keys():
            selogin.add(login, seuser, serange)
            change = True
        else:
            selogin.modify(login, seuser, serange)

    except ValueError:
        e = get_exception()
        module.fail_json(msg="%s: %s\n" % (e.__class__.__name__, str(e)))
    except IOError:
        e = get_exception()
        module.fail_json(msg="%s: %s\n" % (e.__class__.__name__, str(e)))
    except KeyError:
        e = get_exception()
        module.fail_json(msg="%s: %s\n" % (e.__class__.__name__, str(e)))
    except OSError:
        e = get_exception()
        module.fail_json(msg="%s: %s\n" % (e.__class__.__name__, str(e)))
    except RuntimeError:
        e = get_exception()
        module.fail_json(msg="%s: %s\n" % (e.__class__.__name__, str(e)))

    return change


def semanage_login_del(module, login, seuser, do_reload, sestore=''):
    """ Delete linux user to SELinux user mapping

    :type module: AnsibleModule
    :param module: Ansible module

    :type login: str
    :param login: a Linux User or a Linux group if it begins with %

    :type seuser: str
    :param proto: An SELinux user ('__default__', 'unconfined_u', 'staff_u', ...), see 'semanage login -l'

    :type do_reload: bool
    :param do_reload: Whether to reload SELinux policy after commit

    :type sestore: str
    :param sestore: SELinux store

    :rtype: bool
    :return: True if the policy was changed, otherwise False
    """
    try:
        selogin = seobject.loginRecords(sestore)
        selogin.set_reload(do_reload)
        change = False
        all_logins = selogin.get_all()
        # module.fail_json(msg="%s: %s %s" % (all_logins, login, sestore))
        if login in all_logins.keys():
            selogin.delete(login)
            change = True

    except ValueError:
        e = get_exception()
        module.fail_json(msg="%s: %s\n" % (e.__class__.__name__, str(e)))
    except IOError:
        e = get_exception()
        module.fail_json(msg="%s: %s\n" % (e.__class__.__name__, str(e)))
    except KeyError:
        e = get_exception()
        module.fail_json(msg="%s: %s\n" % (e.__class__.__name__, str(e)))
    except OSError:
        e = get_exception()
        module.fail_json(msg="%s: %s\n" % (e.__class__.__name__, str(e)))
    except RuntimeError:
        e = get_exception()
        module.fail_json(msg="%s: %s\n" % (e.__class__.__name__, str(e)))

    return change


def main():
    module = AnsibleModule(
        argument_spec={
                'login': {
                    'required': True,
                    # 'default': '__default__',
                },
                'seuser': {
                    'required': True,
                },
                'serange': {
                    'required': False
                },
                'state': {
                    'choices': ['present', 'absent'],
                    'default': 'present'
                },
                'reload': {
                    'required': False,
                    'type': 'bool',
                    'default': 'yes',
                },
            },
        supports_check_mode=True
    )
    if not HAVE_SELINUX:
        module.fail_json(msg="This module requires libselinux-python")

    if not HAVE_SEOBJECT:
        module.fail_json(msg="This module requires policycoreutils-python")

    if not selinux.is_selinux_enabled():
        module.fail_json(msg="SELinux is disabled on this host.")

    login = module.params['login']
    seuser = module.params['seuser']
    serange = module.params['serange']
    state = module.params['state']
    do_reload = module.params['reload']

    result = {
        'login': login,
        'seuser': seuser,
        'serange': serange,
        'state': state,
    }

    if state == 'present':
        result['changed'] = semanage_login_add(module, login, seuser, do_reload, serange)
    elif state == 'absent':
        result['changed'] = semanage_login_del(module, login, seuser, do_reload)
    else:
        module.fail_json(msg='Invalid value of argument "state": {0}'.format(state))

    module.exit_json(**result)


if __name__ == '__main__':
    main()
