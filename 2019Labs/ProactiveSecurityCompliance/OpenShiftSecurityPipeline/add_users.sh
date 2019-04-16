#!/bin/bash
rm htpasswd
htpasswd -c -b htpasswd student1 password

for i in `seq 2 50`; do
  htpasswd -b htpasswd student${i} password
done

oc create secret generic htpass-secret --from-file=htpasswd=./htpasswd -n openshift-config
oc apply -f htpasswd_cr.yaml -n openshift-config
