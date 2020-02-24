#!/bin/bash

if [[ "$0" =~ run.sh$ ]]; then
  playbook="main.yml"
elif [[ "$0" =~ stop.sh$ ]]; then
  playbook="destroy.yml"
else
  echo "Invalid script $0 executed."
fi

if [ "$1" == "" ]; then
  echo "$0 rhel|selinux"
  echo "Please specify either rhel (RHEL Security) or selinux (SELinux Policy) for a lab to create or destroy."
  exit 1
fi

cd ~/aws/testrun/agnosticd/ansible
if [ "$1" == "rhel" ]; then
  ansible-playbook -e @~/aws/myconfigs/sample_vars.yml -e @~/.aws/opentlc_creds.yml $playbook
elif [ "$1" == "selinux" ]; then
  ansible-playbook -e @~/aws/myconfigs/sample_vars-selinux.yml -e @~/.aws/opentlc_creds.yml $playbook
else
  echo "Lab name $1 is invalid. Please specify either rhel (RHEL Security) or selinux (SELinux Policy) for a lab to create or destroy."
fi
