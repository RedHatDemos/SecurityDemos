#!/bin/bash
SERVER='sat6.summit.example.com'
USER='admin'
PASS=$1
/usr/local/sbin/bootstrap.py -l $USER -p $PASSWORD -s $SERVER -o 'Default Organization' -L 'Default Location' -g base_with_puppet_75  -a rhel7beta  -f
