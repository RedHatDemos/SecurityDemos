# CloudForms + Satellite 6 + Ansible OpenSCAP Playbooks

This repo contains two playbooks that leverage Satellite 6's built-in scanning capability.  For an OpenScap playbook that does not rely on Satellite 6, see my [ansible-openscap](https://github.com/jritenour/ansible-openscap) repo.  

These playbooks are designed to be ran within the context of Red Hat CloudForms, specifically using the built-in Ansible Tower integration.  With this, you can create a job template in Tower using these playbooks,then create a custom button in CloudForms using Ansible_Tower_Job as the request, and job_template_name/*name of job* as the attribute/value pair, then use those buttons to launch your scan & subsequent remediation against your CloudForms managed VMs.

## cf-ans-sat-scan.yml
Very straight forward, this is simply running the foreman_scap_client command against the first profile listed in the config file on the client.  Note that this playbook assumes the client has been registered in Satellite, has Puppet installed, and assigned a compliance profile in Satellite.  The report will then be available under the compliance reports section of CF.

## cf-ans-sat-fix.yml

This playbook is indtended to remediate the results of a SCAP scan.  Again, this assumes the client is registered to Satellite, and has been assigned a profile.  

At this point, the remediation playbook will make use of Satellite's OpenSCAP profile, but due to limitations in the API with regard to the foreman scap client at the moment, it does not leverage the previously saved results.  Instead it does do a complete scan as part of the remediation.  I'll address this with a more elegant solution at some point in time.

## Variables exposed

Both the scan & the remediation playbooks make use of the "policy_id" variable, which is simply the ID number of the policy in Satellite.  See /api/v2/compliance/policies for the complete listing with IDs.
The remediation playbook has a "sat_server" variable to build the URL to download the scap content file from.  The format for this should be "https://satellte ip or hostname:9090".
