#!/usr/bin/python
# -*- coding: utf-8 -*-

# (c) 2015, Jonathan Davila <jdavila@ansible.com>
#
# This file is part of Ansible
#
# Ansible is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ansible is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ansible.  If not, see <http://www.gnu.org/licenses/>.

import os, re
from os.path import isfile, join


DOCUMENTATION = '''
---
module: pam
author: "Jonathan I. Davila (@defionscode)"
version_added: "2.1"
short_description: Manage PAM configuration file(s) entries
description:
     - "The M(pam) module manages pam entries. By default it will look for configs in /etc/pam.d/ with /etc/pam.conf as a fall back."
options:
    service:
        description:
            - "Typically the familiar name of the corresponding application: login and su are good examples."
        required: true
    type:
        description:
            -  "The management group that the rule corresponds to. It is used to specify which of the management groups the subsequent module is to be associated with."
        required: true
        choices: ['account', 'auth', 'password', 'session', '-account', '-auth', '-password', '-session']
    control:
        description:
            - "Indicates the behavior of the PAM-API should the module fail to succeed in its authentication task. There are two types of syntax for this control field: the simple one has a single simple keyword; the more complicated one involves a square-bracketed selection of value=action pairs. If using complex controls, be sure to wrap the value in quotes. Due to the complex nature of this field, for valid input please see U(http://www.linux-pam.org/Linux-PAM-html/sag-configuration-file.html)"
        required: true
    pam_module:
        description:
            - "Either the full filename of the PAM to be used by the application (it begins with a '/'), or a relative pathname from the default module location: /lib/security/ or /lib64/security/, depending on the architecture. For relative paths, by default it will only look in /lib/security/ or /lib64/security/."
        required: true
    backup:
        description:
            - "Create a backup file including the timestamp information so you can get the original file back if you somehow clobbered it incorrectly."
        required: false
        choices: [ "yes", "no" ]
        default: "no"
    arguments:
        description:
            - "A space separated list of tokens that can be used to modify the specific behavior of the given PAM. Such arguments will be documented for each individual PAM module."
        required: false
    additional_module_paths:
        description:
            - "A list of additional full paths in which to search for PAM modules"
        required: false
    create_config:
        description:
            - If you have a system that uses /etc/pam.d/ you can set this to True if you'd like Ansible to create the pam.d entry should it not already exist. As per the spec, the config file will be named after whatever is specified for I(service)
        required: false
        default: "no"
    before_line:
        description:
            - If supplied, it will place the desired PAM entry before the line specified here. Note that this is smart enough to ignore white and tab spaces when searching.
    after_line:
        description:
            - If supplied, it will place the desired PAM entry after the line specified here. Note that this is smart enough to ignore white and tab spaces when searching.
    state:
        description:
            - Whether you want the PAM entry to be present or absent. Note that it will search for I(service), I(pam_module), , I(control), and I(type). If all four are in the entry, the entry will be removed.

'''

EXAMPLES = '''

# Create a PAM entry for my_service
- pam:
    service: my_service
    type: session
    control: '[default=4]'
    pam_module: pam_unix.so
    state: present

# Create a PAM entry for my_service and create a config in /etc/pam.d/my_service if it's not present.
- pam:
    service: my_service
    type: password
    control: '[default=die]'
    pam_module: pam_namespace.so
    create_config: yes
    state: present

# Create a PAM entry for my_service after the 'password required  pam_unix.so' entry
- pam:
    service: my_service
    type: session
    control: requisite
    pam_module: pam_namespace.so
    after_line: password required  pam_unix.so
    state: present

'''
RETURN = '''
backup_file:
    description: Path to backup file
    returned: always
    type: string or null
    sample: "/path/to/file.txt"
config_path:
    description: The path to the PAM config file
    returned: always
    type: string
    sample: "/etc/pam.d/my_service"
pam_entry:
    description: The entry as it will appear inside of the PAM config file
    returned: always
    type: string
    sample: "auth optional pam_namespace.so"

'''

REGEX_PATTERN = '[\s\t\n]*(?![^\[\]]*\])'

def pamd_in_use():
    """
    Checks if the system uses pam.d. This is important because when pamd
    is in use then the service name takes the place of the file name;
    without pamd the service names is placed on the left most column of pam.conf
    """
    if os.path.exists('/etc/pam.d/'):
        return True
    else:
        return False


def create_config(service):
    """
    Creates an empty config file in pam.d when the user specifies
    create_config=True and when the config does not already exist
    """
    service_file = open('/etc/pam.d/%s' % service, 'a')
    service_file.close()
    return '/etc/pam.d/%s' % service


def config_exists(service):
    """Checks for the existence of a pam.d config"""
    if os.path.exists('/etc/pam.d/%s' % service):
        return True
    else:
        return False


def is_valid_type(pam_type, **kwargs):
    """
    Checks if the type supplied is valid. Source referenced can be found at
    http://www.linux-pam.org/Linux-PAM-html/sag-configuration-file.html
    """
    if pam_type in kwargs['VALID_TYPES']:
        return True
    else:
        return False


def check_if_valid_control(module, pam_control, **kwargs):
    '''
    Checks if the control is valid. It also does a check of complex controls.
    Source referenced can be found at
    http://www.linux-pam.org/Linux-PAM-html/sag-configuration-file.html
    '''
    if pam_control in kwargs['VALID_CONTROLS']:
        return True
    elif pam_control.startswith('['):
        #Complex controls start with a bracket
        complex_controls = pam_control[1:-1].split(' ') # When you have something like [default=die success=1] this makes it a proper list of control k/v pairs
        for control in complex_controls:
            control_key, control_value = control.split('=')
            if control_key in kwargs['VALID_COMPLEX_CONTROL_KEYS']:
                continue
            else:
                module.fail_json(msg="Bad control key specified. %s is not a valid complex control key. Valid complex keys are: %s" % (control_key, kwargs['VALID_COMPLEX_CONTROLS']))

            if control_value in kwargs['VALID_COMPLEX_CONTROL_VALUES'] or isinstance(control_value, int):
                return True
            else:
                module.fail_json(msg="Bad control value specified. %s is not a valid complex control value. Valid complex values are integers or: %s" % (control_value, kwargs['VALID_COMPLEX_CONTROL_VALUES']))


def get_config_lines(path):
    '''Returns a list in which every element is a line of the current config file'''
    # Python 2.4 compatible file operations
    try:
        config = open(path, 'r')
    except IOError:
        config = open('/etc/pam.conf', 'r')
    config_lines = config.readlines()
    config.close()
    return config_lines


def is_full_line_present(lines, entry):
    '''Checks to see if the user supplied PAM config args are already present as a line'''
    is_present = False
    entry_args = re.split(REGEX_PATTERN, entry)

    for config_line in lines:
        # This attempts to determine if the module supplied args are currently present in the config
        if all(pam_arg in config_line for pam_arg in entry_args):
            is_present = True

    return is_present


def add_to_config(pam_entry, reference_line, config_lines, config_path, placement=None):
    '''Intelligently adds the params as a proper PAM config line'''
    changed = False
    ref_line_args = re.split(REGEX_PATTERN, reference_line)
    len_limit = len(ref_line_args)
    entry_args = re.split(REGEX_PATTERN, pam_entry)[:len_limit]

    for line in config_lines:
        # Here we grab the index location of the reference line which will place the
        # 'pam_entry' either before or after this line.
        if all(arg in line for arg in ref_line_args):
            ref_location = config_lines.index(line)
            break

    if placement == 'before':
        if set( re.split(REGEX_PATTERN, config_lines[ref_location - 1]) ) == set(entry_args):
            changed = False
        else:
            config_lines.insert(ref_location, pam_entry + '\n')
            changed = True
    elif placement == 'after':
        try:
            if set( re.split(REGEX_PATTERN, config_lines[ref_location + 1]) ) == set(entry_args):
                changed = False
            else:
                config_lines.insert(ref_location + 1, pam_entry + '\n')
                changed = True
        except IndexError:
            # This occurs when using after_line in the module args and the after_line is the last line
            # of the file. When this happens, we simply append instead of insert.
            config_lines.append(pam_entry + '\n')
            changed = True
    # Python 2.4 compatible file operations
    conf = open(config_path, 'w')
    try:
        for line in config_lines:
            conf.write(line.strip(' '))
    finally:
        conf.close()

    return changed


def rule_already_defined(service, pam_type, pam_module, pam_control, config_lines):
    '''
    Checks if the rule is already defined. It keys off the service, type, control, and module.
    Makes the most sense when wanting to modify PAM arguments.
    '''
    if pamd_in_use():
        for line in config_lines:
            # Here we simply extract all the relevant portions of each PAM rule
            if not line.startswith('#'):
                cline = filter(None, re.split(REGEX_PATTERN, line))
                if len(cline) > 0:
                    l_type = str(cline[0])
                    l_control = str(cline[1])
                    l_module = str(cline[2])

                    if pam_type == l_type and l_module == pam_module and l_control == pam_control:
                        # If all the sections match with what the user via the Ansible task then we
                        # return the index of the rule
                        return config_lines.index(line)
                else:
                    continue

            else:
                continue

        return False

    else:
        for line in config_lines:
            cline       = filter(None, re.split(REGEX_PATTERN, line))
            l_service   = cline[0]
            l_type      = cline[1]
            l_control =   str(cline[2])
            l_module    = cline[3]

            if pam_type == l_type and l_module == pam_module and service == l_service and l_control == pam_control:
                return config_lines.index(line)
            else:
                continue

        return False


def modify_rule(module, config_path, rule_index, config_lines, **kwargs):
    '''
    Used when the rule already exists and a modification needs to PAM module arguments.
    '''
    rule_string = config_lines[rule_index] # rule_index is grabbed from the call to rule_already_defined()
    rule_split = re.split(REGEX_PATTERN, rule_string)

    if pamd_in_use():
        # These values are static
        args_index = 3
    else:
        args_index = 4

    if kwargs['arguments']:
        if not set(kwargs['arguments'].split()).issubset(filter(None, rule_split[args_index:])):
            pam_conf = open(config_path, 'w')
            try:
                for line_num, rule in enumerate(config_lines):
                    if line_num != rule_index:
                        pam_conf.write(rule.strip(' '))
                    else:
                        pam_conf.write('    '.join(rule_split[:3]) + '    ' + kwargs['arguments'] + '\n')
            finally:
                pam_conf.close()

            return True
        else:
            return False


def placed_correctly(config_lines, current_location, ref_line=None, placement=None):
    '''Checks to see if the generated line is in the proper spot as dictated by before_line and after_line'''
    ref_line = re.split(REGEX_PATTERN, ref_line)
    len_limit = len(ref_line) #This is done b/c we only want to compare to first 3 or 4 columns depending on pamd usage.

    if placement == 'after':

        if current_location - 1 >= 0:
            line_before_entry = filter(None, re.split(REGEX_PATTERN, config_lines[current_location - 1]))[:len_limit]
        else:
            return False

        if set(line_before_entry) == set(ref_line):
            return True
        else:
            return False

    elif placement == 'before':

        try:
            line_after_entry = filter(None, re.split(REGEX_PATTERN, config_lines[current_location + 1]))[:len_limit]
        except Exception:
            line_after_entry = []

        if set(line_after_entry) == set(ref_line):
            return True
        else:
            return False


def move_line(path=None, content=None, pam_entry=None, pam_entry_index=None, ref_line=None, placement=None):
    '''Used when the generated line is not in its proper spot. This function moves it to the proper location'''
    # Since this only gets called when placed_correctly() returns False we just delete the offending line from the list then
    # we add it back into the correct spot later.

    content = filter(None, content)
    ref_line = re.split(REGEX_PATTERN, ref_line)
    pam_entry += '\n'
    len_limit = len(ref_line)

    for line in content:
        c_line = filter(None, re.split(REGEX_PATTERN, line))[:len_limit]

        if set(c_line) == set(ref_line):
            del content[pam_entry_index]
            content = filter(None, content)
            ref_index = content.index(line) + 1
            break

    if placement == 'after':
        try:
            content.insert(ref_index + 1, pam_entry)
        except IndexError:
            content.append(pam_entry)

        config = open(path, 'w')
        try:
            for line in content:
                config.write(line.strip(' '))
        finally:
            config.close()

    elif placement == 'before':
        if ref_index - 1 > 0:
            content.insert(ref_index, pam_entry)
        else:
            content.insert(0, pam_entry)
        config = open(path, 'w')
        try:
            for line in content:
                config.write(line.strip(' '))
        finally:
            config.close()
    return


def delete_rule(path, index, original_lines):
    ''' Deletes a rule'''
    del original_lines[index]
    config = open(path, 'w')
    try:
        for line in original_lines:
            config.write(line.strip(' '))
    finally:
        config.close()
    return


def pam_manager(**kwargs):
    '''
     This is where logic is orchestrated. Takes the module argumetns and establishes some common variables
     and conducts actions based on the prescence of various arguments and pam.d vs pam.conf
    '''
    module              = kwargs['module']
    service             = kwargs['service']
    pam_type            = kwargs['pam_type']
    control             = kwargs['control']
    pam_module          = kwargs['pam_module']
    arguments           = kwargs['arguments']
    add_paths           = kwargs['add_paths']
    make_config         = kwargs['make_config']
    before_line         = kwargs['before_line']
    after_line          = kwargs['after_line']
    changed             = kwargs['changed']
    config_path         = kwargs['config_path']
    config_lines        = kwargs['config_lines']
    current_rule_index  = kwargs['current_rule_index']
    mod_args            = kwargs['mod_args']
    pam_spec_args       = kwargs['pam_spec_args']
    state               = kwargs['state']
    backup_file         = kwargs['backup_file']

    if pamd_in_use():
        # Attempted to use \t characters to make it more uniform but the behavior was inconsistent
        pam_entry = "%s      %s      %s      %s" % (pam_type, control, pam_module, arguments)
    else:
        pam_entry = "%s      %s      %s      %s      %s" % (service, pam_type, control, pam_module, arguments)

    if state == 'present':
        if pamd_in_use():
            if not config_exists(service) and make_config:
                changed = True
                config_path = create_config(service)
                module.append_to_file(config_path, pam_entry.rstrip())
                module.exit_json(changed=changed, config_path=config_path, pam_entry=pam_entry.rstrip().expandtabs(), backup_file=backup_file)

            elif not config_exists(service) and not make_config:
                module.fail_json(msg="The service config: /etc/pam.d/%s, could not be found. If you'd like for the config to be created, please the create_config argument to True" % service)


        if is_full_line_present(config_lines, pam_entry) and not before_line and not after_line:
            module.exit_json(changed=changed, config_path=config_path, pam_entry=pam_entry.rstrip().expandtabs(), backup_file=backup_file, line=401)

        elif before_line:
            if isinstance(current_rule_index, int) and not isinstance(current_rule_index, bool): #Here when the index of the line was 0 or 1 it was getting translated into boolean value.
                changed = modify_rule(module, config_path, current_rule_index, config_lines, **mod_args)

            if not is_full_line_present(config_lines, pam_entry) and not changed:
                if is_full_line_present(config_lines, before_line):
                    changed = add_to_config(pam_entry, before_line, config_lines, config_path, placement='before')
                    module.exit_json(changed=changed, config_path=config_path, pam_entry=pam_entry.rstrip().expandtabs(), backup_file=backup_file)
                else:
                    module.fail_json(changed=changed, msg='The before_line argument was used but the line: %s, could not be found.' % before_line)

            elif not placed_correctly(config_lines, current_rule_index, ref_line=before_line, placement='before'):
                move_line(path=config_path, content=config_lines, pam_entry=pam_entry, pam_entry_index=current_rule_index, ref_line=before_line, placement='before')
                changed = True
                module.exit_json(changed=changed, config_path=config_path, pam_entry=pam_entry.rstrip().expandtabs(), backup_file=backup_file)
            else:
                module.exit_json(changed=changed, config_path=config_path, pam_entry=pam_entry.rstrip().expandtabs(), backup_file=backup_file)

        elif after_line:
            if isinstance(current_rule_index, int) and not isinstance(current_rule_index, bool):
                changed = modify_rule(module, config_path, current_rule_index, config_lines, **mod_args)

            if not is_full_line_present(config_lines, pam_entry) and not changed:
                if is_full_line_present(config_lines, after_line):
                    changed = add_to_config(pam_entry, after_line, config_lines, config_path, placement='after')
                    module.exit_json(changed=changed, config_path=config_path, pam_entry=pam_entry.rstrip().expandtabs(), backup_file=backup_file)
                else:
                    module.fail_json(changed=changed, msg='The after_line argument was used but the line: %s, could not be found.' % after_line)

            elif not placed_correctly(config_lines, current_rule_index, ref_line=after_line, placement='after'):
                move_line(path=config_path, content=config_lines, pam_entry=pam_entry, pam_entry_index=current_rule_index, ref_line=after_line, placement='after')
                changed = True
                module.exit_json(changed=changed, config_path=config_path, pam_entry=pam_entry.rstrip().expandtabs(), backup_file=backup_file)
            else:
                module.exit_json(changed=changed, config_path=config_path, pam_entry=pam_entry.rstrip().expandtabs(), backup_file=backup_file)

        else:
            if isinstance(current_rule_index, int) and not isinstance(current_rule_index, bool):
                changed = modify_rule(module, config_path, current_rule_index, config_lines, **mod_args)
                module.exit_json(changed=changed, config_path=config_path, pam_entry=pam_entry.rstrip().expandtabs(), backup_file=backup_file, line=401)

            else:
                changed = True
                module.append_to_file(config_path, pam_entry.rstrip())
                module.exit_json(changed=changed, config_path=config_path, pam_entry=pam_entry.rstrip().expandtabs(), backup_file=backup_file, line=406)

    elif state == 'absent':
        if isinstance(current_rule_index, int) and not isinstance(current_rule_index, bool):
            module.exit_json(changed=changed, config_path=config_path, pam_entry=pam_entry.rstrip().expandtabs(), backup_file=backup_file)

        else:
            changed = True
            delete_rule(config_path, current_rule_index, config_lines)
            module.exit_json(changed=changed, config_path=config_path, pam_entry=pam_entry.rstrip().expandtabs(), backup_file=backup_file)


def main():
    pam_spec_args = dict(
        VALID_TYPES                     = ['account', 'auth', 'password', 'session', '-account', '-auth', '-password', '-session'],
        PAM_MOD_DIRS                    = ['/lib/security', '/lib64/security'],
        VALID_PAM_MODULES               = [],
        PAMD_PATH                       = '/etc/pam.d/',
        VALID_CONTROLS                  = ['required', 'requisite', 'sufficient', 'optional', 'include', 'substack' ],
        VALID_COMPLEX_CONTROL_KEYS      = ['success', 'open_err', 'symbol_err', 'service_err', 'system_err', 'buf_err', 'perm_denied', 'auth_err', 'cred_insufficient', 'authinfo_unavail', 'user_unknown', 'maxtries', 'new_authtok_reqd', 'acct_expired', 'session_err', 'cred_unavail', 'cred_expired', 'cred_err', 'no_module_data', 'conv_err', 'authtok_err', 'authtok_recover_err', 'authtok_lock_busy', 'authtok_disable_aging', 'try_again', 'ignore', 'abort', 'authtok_expired', 'module_unknown', 'bad_item', 'conv_again', 'incomplete', 'default'],
        VALID_COMPLEX_CONTROL_VALUES    = ['ignore', 'bad', 'die', 'ok', 'done', 'reset'],
    )

    module = AnsibleModule(argument_spec=dict(
        service                 = dict(required=True),
        type                    = dict(required=True),
        control                 = dict(required=True),
        pam_module              = dict(required=True),
        arguments               = dict(required=False),
        additional_module_paths = dict(required=False, default=''),
        create_config           = dict(required=False, type='bool', default=False),
        before_line             = dict(required=False, default=None),
        after_line              = dict(required=False, default=None),
        state                   = dict(required=True, choices=['present', 'absent']),
        backup                  = dict(required=False, default=False, type='bool')))

    service             = module.params['service']
    pam_type            = module.params['type']
    control             = module.params['control']
    pam_module          = module.params['pam_module']
    arguments           = module.params['arguments']
    add_paths           = module.params['additional_module_paths']
    make_config         = module.params['create_config']
    before_line         = module.params['before_line']
    after_line          = module.params['after_line']
    state               = module.params['state']
    backup              = module.params['backup']
    changed             = False

    if pamd_in_use():
        config_path     = '/etc/pam.d/%s' % service
    else:
        config_path     = '/etc/pam.conf'

    config_lines        = get_config_lines(config_path)
    current_rule_index  = rule_already_defined(service, pam_type, pam_module, control, config_lines)
    mod_args            = dict(control=control, arguments=arguments)

    if backup:
        backup_file = module.backup_local(config_path)
    else:
        backup_file = None

    if add_paths:
        pam_spec_args['PAM_MOD_DIRS'] += add_paths

    if not arguments:
        arguments = ''

    for path in pam_spec_args['PAM_MOD_DIRS']:
        valid_modules = [ pam_mod for pam_mod in os.listdir(path) if isfile(join(path,pam_mod)) ]
        pam_spec_args['VALID_PAM_MODULES'] += valid_modules

    if not is_valid_type(pam_type, **pam_spec_args):
        module.fail_json(msg="Invalid PAM type: %s, specified. Must be one of: %s" % (pam_type, pam_spec_args['VALID_TYPES']))

    if not pam_module in pam_spec_args['VALID_PAM_MODULES'] and not pam_module.startswith('/'):
        module.fail_json(msg="Invalid PAM module: %s, specified. Must be one of: %s" % (pam_module, pam_spec_args['VALID_PAM_MODULES']))

    check_if_valid_control(module, control, **pam_spec_args)

    pam_manager_args = dict(module=module, service=service, pam_type=pam_type, control=control,
                            pam_module=pam_module, arguments=arguments, add_paths=add_paths,
                            make_config=make_config, before_line=before_line, after_line=after_line,
                            changed=changed, config_path=config_path, config_lines=config_lines,
                            current_rule_index=current_rule_index, mod_args=mod_args,
                            pam_spec_args=pam_spec_args, state=state, backup_file=backup_file)

    pam_manager(**pam_manager_args)


from ansible.module_utils.basic import *

if __name__ == '__main__':
    main()
