firewall
========

This role configures the firewall on RHEL-6 and RHEL-7 machines using the
default firewall system.

For the configuration the role tries to use the firewalld client interface
which is available in RHEL-7. If this failes it tries to use the
system-config-firewall interface which is available in RHEL-6 and in RHEL-7
as an alternative.

Limitations
-----------

### Configuration over Network

The configuration of the firewall could limit access to the machine over the
network. Therefore it is needed to make sure that the SSH port is still
accessible for the ansible server.

### Using MAC addresses

As MAC addresses can no be used in netfilter to identify interfaces, this
role is doing a mapping from the MAC addresses to interfaces for netfilter.
The network needs to be configured before the firewall to be able to get the
mapping to interfaces.
After a MAC address change on the system, the firewall needs to be configured
again if the MAC address has been used in the configuration.

If the MAC address or an interface has been changed in RHEL-6, then it is
needed to adapt the firewall configuration also. For RHEL-7 this could be done
automatically if NetworkManager is controlling the affected interface.

### The Error Case

If the configuration failed or if the firwall configuration limits access to
the machine in a bad way, it is most likely be needed to get physical access
to the machine to fix the issue.

### Rule sorting

If you want to add forwarding rules to an interface that also is masqueraded,
then the masquerading rules needs to be sorted before the forwarding rule.


Usage
-----

This configures the firewall:

    $ ansible-playbook -i hostname, example-firewall.yml


Variables
---------

These are the variables that can be passed to the role:

    firewall_setup_default_solution: false

This turns off the installation and start of the default firewall solution for the specific Fedora or RHEL release. This is intended for users of system-config-firewall on RHEL-7 or Fedora releases.

    service: 'ftp'
    service: [ 'ftp', 'tftp' ]

Name of a service or service list to add or remove inbound access to. The service needs to be defined in firewalld or system-config-firewall/lokkit configuration.

    port: '443/tcp'
    port: [ '443/tcp', '443/udp' ]

Port or port range or a list of them to add or remove inbound access to. It needs to be in the format ```<port>[-<port>]/<protocol>```.

    trust: 'eth0'
    trust: [ 'eth0', 'eth1' ]

Interface to add or remove to the trusted interfaces.

    trust_by_mac: "00:11:22:33:44:55"
    trust_by_mac: [ "00:11:22:33:44:55", "00:11:22:33:44:56" ]

Interface to add or remove to the trusted interfaces by MAC address or MAC address list. Each MAC address will automatically be mapped to the interface that is using this MAC address.

    masq: 'eth2'
    masq: [ 'eth2', 'eth3' ]

Interface to add or remove to the interfaces that are masqueraded.

    masq_by_mac: "11:22:33:44:55:66"
    masq_by_mac: [ "11:22:33:44:55:66", "11:22:33:44:55:67", ]

Interface to add or remove to the interfaces that are masqueraded by MAC address or MAC address list. Each MAC address will automatically be mapped to the interface that is using this MAC address.

    forward_port: 'eth0;447/tcp;;1.2.3.4'
    forward_port: [ 'eth0;447/tcp;;1.2.3.4', 'eth0;448/tcp;;1.2.3.5' ]

Add or remove port forwarding for ports or port ranges over an interface. It needs to be in the format ```<interface>;<port>[-<port>]/<protocol>;[<to-port>];[<to-addr>]```.

    forward_port_by_mac: '00:11:22:33:44:55;447/tcp;;1.2.3.4'
    forward_port_by_mac: [ '00:11:22:33:44:55;447/tcp;;1.2.3.4', '00:11:22:33:44:56;447/tcp;;1.2.3.4' ]

"Add or remove port forwarding for ports or port ranges over an interface itentified ba a MAC address or MAC address list. It needs to be in the format ```<mac-addr>;<port>[-<port>]/<protocol>;[<to-port>];[<to-addr>]```. Each MAC address will automatically be mapped to the interface that is using this MAC address.

    state: 'enabled' | 'disabled'

Enable or disable the entry.

### Example Playbook

    - hosts: localhost
      vars:
        firewall:
          - { service: [ 'tftp', 'ftp' ],
              port: [ '443/tcp', '443/udp' ],
              trust: [ 'eth0', 'eth1' ],
              masq: [ 'eth2', 'eth3' ],
              forward_port: [ 'eth2;447/tcp;;1.2.3.4',
                              'eth2;448/tcp;;1.2.3.5' ],
              state: 'enabled' }
          - { service: 'tftp', state: 'enabled' }
          - { port: '443/tcp', state: 'enabled' }
          - { trust: 'foo', state: 'enabled' }
          - { trust_by_mac: '00:11:22:33:44:55', state: 'enabled' }
          - { masq: 'foo2', state: 'enabled' }
          - { masq_by_mac: '00:11:22:33:44:55', state: 'enabled' }
          - { forward_port: 'eth0;445/tcp;;1.2.3.4', state: 'enabled' }
          - { forward_port_by_mac: '00:11:22:33:44:55;445/tcp;;1.2.3.4',
              state: 'enabled' }
      roles:
        - firewall

The block with several services, ports, etc. will be applied at once. If there is something wrong in the block it will fail as a whole.

It is also possible to use the more common syntax:

    - hosts: localhost
      vars:
        firewall:
          service: 'tftp'
          state: 'enabled'
      roles:
        - firewall

To do only one change.

# License

GPLv2+
