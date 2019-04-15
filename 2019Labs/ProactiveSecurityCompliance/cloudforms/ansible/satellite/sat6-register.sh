#!/bin/bash
SERVER='sat64.example.com'
USER='admin'
PASS=''
/usr/local/sbin/bootstrap.py -l ${USER} -p ${PASS} -s ${SERVER} -o 'Default Organization' -L 'Default Location' -g base_with_puppet_75  -a rhel7beta  -f
