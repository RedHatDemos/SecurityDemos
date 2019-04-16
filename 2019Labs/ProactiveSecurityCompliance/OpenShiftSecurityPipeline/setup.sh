#!/bin/bash

set -e

OPENSHIFT_API=https://api.cluster-1283.1283.openshiftworkshop.com:6443
OPENSHIFT_USER=kubeadmin
OPENSHIFT_PASSWORD=UPDATE_PASSWORD_HERE

oc login -u ${OPENSHIFT_USER} -p ${OPENSHIFT_PASSWORD} ${OPENSHIFT_API}

# Import latest EAP images
#oc import-image jboss-eap64-openshift -n openshift --all --from=registry.access.redhat.com/jboss-eap-6/eap64-openshift --confirm  || true
oc import-image jboss-eap70-openshift -n openshift --all --from=registry.access.redhat.com/jboss-eap-7/eap70-openshift --confirm  --scheduled || true

# TODO Convert code to springboot


# Import older image for demo purposes
#oc import-image openshift/jboss-eap70-openshift:1.3 --from=registry.access.redhat.com/jboss-eap-7/eap70-openshift:1.3 --confirm -n openshift  || true

# Delete projects
oc delete project pqc-dev && oc delete project pqc-prod && oc delete project pqc-support && oc delete project pqc-test || true

# Create projects 


oc new-project pqc-support --display-name "PQC Support Infrastructure" || true
oc new-project pqc-dev --display-name "PQC Development Project" || true
oc new-project pqc-test --display-name "PQC Test Project" || true
oc new-project pqc-prod --display-name "PQC Production Project"  || true

# Create the PQC Support Project
oc delete all --all -n pqc-support  || true
oc get pvc | grep -v NAME | awk '{print $1}' | xargs oc delete pvc || true
oc delete template pqc-support -n pqc-support  || true
oc create -f pqc_templates/pqc_support_template.yml -n pqc-support  || true
oc new-app --template=pqc-support -n pqc-support  || true
oc start-build --from-file=./sonarqube/Dockerfile bc/sonarqube-custom --follow --wait --namespace=pqc-support 
oc start-build --from-file=./nexus/Dockerfile bc/nexus-custom --follow --wait --namespace=pqc-support 
oc expose svc/nexus -n pqc-support 
oc expose svc/sonarqube-custom -n pqc-support 


# Create the PQC Development Project
oc delete all --all -n pqc-dev  || true
oc delete template pqc-dev -n pqc-dev  || true
oc create -f pqc_templates/pqc_dev_template.yml -n pqc-dev 
oc new-app --template=pqc-dev -n pqc-dev || true
oc expose svc/pqc-dev  -n pqc-dev

# Create the PQC Test Project
oc delete all --all -n pqc-test  || true
oc delete template pqc-test -n pqc-test  || true
oc create -f pqc_templates/pqc_test_template.yml -n pqc-test 
oc new-app --template=pqc-test -n pqc-test  || true
oc expose svc/pqc-test  -n pqc-test

# Create the PQC Production Project
oc delete all --all -n pqc-prod  || true
oc delete template pqc-prod -n pqc-prod  || true
oc create -f pqc_templates/pqc_prod_template.yml -n pqc-prod 
oc new-app --template=pqc-prod -n pqc-prod  || true
oc expose svc/pqc-prod  -n pqc-prod

oc project pqc-support

#oc create -f jenkins-persistent-lab.yaml -n pqc-support || true
#oc new-app jenkins-persistent-lab -n pqc-support
oc new-app jenkins-persistent -n pqc-support
oc rollout status dc/jenkins -w -n pqc-support

# TODO Create a docker registry in nexus

oc adm policy add-role-to-user edit system:serviceaccount:pqc-support:jenkins -n pqc-dev
oc adm policy add-role-to-user edit system:serviceaccount:pqc-support:jenkins -n pqc-test
oc adm policy add-role-to-user edit system:serviceaccount:pqc-support:jenkins -n pqc-prod

oc new-build https://github.com/kharyam/personal-qualification-calculator.git --strategy=pipeline -n pqc-support
