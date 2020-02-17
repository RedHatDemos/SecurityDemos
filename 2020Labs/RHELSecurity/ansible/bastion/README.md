This playbook provisions the RHEL 7.x bastion host, and pulls down the required tools and git repositiories, and pre-configures the variable files that are used by the agnisticd deployer to create the RHEL 8 hosts.

**NOTE: The AWS keys in this document aren't valid (randomly typed characters!), so don't try to use them**

Instructions:
1. record the variables that are presented when you provision the OpenTLC AWS deployer environment, from the **custom attributes** section:
    
    ```Top level domain: .sandbox744.opentlc.com
    WARNING: with great power comes great responsibility. We monitor usage.
    Your AWS programmatic access:
    aws_access_key_id = AAAAAAAAAAAAAAAAAAAA
    aws_secret_access_key = bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
    SSH Access: ssh generic_naps_ajacocks@bastion.3724.sandbox744.opentlc.com
    SSH password: CCCCCCCCCCCC
    GUID 	3724
    account 	sandboxes-gpte
    className 	PROD_OCP4_AWS_INSTALL_LAB
    nodes 	2
    region 	na_sandboxes_gpte
    remoteScript 	/home/opentlc-mgr/OPEN_Admin/OPENTLC-Deployer/deploy_scripts/ALL_agnosticv.sh
    sandboxzone 	sandbox744.opentlc.com
    service_status 	complete
    sharedEnvironment 	false
    sshHost 	admin.na.shared.opentlc.com
    targetHost 	bastion.3724.sandbox744.opentlc.com
    uuid 	3c09f0bb-9797-4b18-b440-2e03d353792c``` 

2. Edit the file **inventory** in this directory, and fill in the above values, like this:
   
    ```[bastion]
    # put the name of the bastion host (targetHost), here
    bastion.3724.sandbox744.opentlc.com
    [bastion:vars]
    # put your AWS access key ID, and secure access key, here
    AWS_ACCESS_KEY_ID=AAAAAAAAAAAAAAAAAAAA
    AWS_SECRET_ACCESS_KEY=bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
    # put the DNS domain here, not including any leading or trailing periods
    dns_domain=sandbox744.opentlc.com
    # put the AWS region, that you wish to deploy on, here
    region=us-east-1
    # put your email address here
    email=alexander@redhat.com
    # put your guid (your *nix user name, no special characters), here
    guid=ajacocks
    ansible_connection=ssh
    # put the user and password, from OpenTLC CloudForms, here
    ansible_user=generic_naps_ajacocks
    ansible_password=CCCCCCCCCCCC```

3. Run the playbook, to configure the bastion host:
   
    ```$ ansible-playbook main.yml```

4. Once the provisioning completes, login to the bastion host, as directed by the OpenTLC variables:
   
    ```$ ssh generic_naps_ajacocks@bastion.3724.sandbox744.opentlc.com```

5. Change directories to **~/aws/testrun/agnosticd/ansible** and execute the playbook, to build the RHEL 8 hosts:
   
    ```$ ansible-playbook main.yml -e @~/aws/myconfigs/sample_vars.yml -e @~/.aws/opentlc_creds.yml```

