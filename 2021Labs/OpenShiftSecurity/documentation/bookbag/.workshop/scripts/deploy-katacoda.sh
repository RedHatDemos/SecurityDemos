#!/bin/bash

SCRIPTS_DIR=`dirname $0`

SETTINGS_NAME=katacoda

. $SCRIPTS_DIR/setup-environment.sh

# Run Katacoda script which waits on OpenShift cluster being ready.

/usr/local/bin/launch.sh

# Make sure that cluster is ready. Gauge this by continually trying to
# to add ability to pull images to any users.

for i in {1..200}; do
    oc policy add-role-to-user system:image-puller system:anonymous && \
        break || sleep 1;
done

# Start pulling down workshop image and console image in background.
# This will hopefully speed things up while set up everything else.

echo "### Start pulling down workshop and console images."

docker pull "$WORKSHOP_IMAGE" > /dev/null 2>&1 &
docker pull "$CONSOLE_IMAGE" > /dev/null 2>&1 &

# Now create the volumes. Create a fixed number for now.

echo "### Create persistent volumes."

for i in $(seq -f "%02g" 1 10); do
    mkdir -p /data/pv-$i
done

chmod 0777 /data/pv-*

chcon -t svirt_sandbox_file_t /data/pv-*

oc apply -f $SCRIPTS_DIR/katacoda-volumes.json

# Grant developer cluster admin access.

echo "### Give developer cluster admin access."

oc adm policy add-cluster-role-to-user cluster-admin developer > /dev/null 2>&1

# Login as developer rather than system:admin.

echo "### Login as developer to OpenShift."

SERVER_ADDRESS=`oc get --raw /.well-known/oauth-authorization-server | grep '"issuer":' | sed -e 's%.*https://%%' -e 's%",%%'`
CLUSTER_SUBDOMAIN=`echo $SERVER_ADDRESS | sed -e 's/-8443-/-80-/' -e 's/:.*//'`

oc login -u developer -p developer --insecure-skip-tls-verify https://$SERVER_ADDRESS > /dev/null

echo "### Deploying workshop using Homeroom."

oc new-project workshop > /dev/null

cat >> $WORKSHOP_DIR/katacoda-settings.sh << EOF
WORKSHOP_NAME=workshop
DASHBOARD_MODE=cluster-admin
OPENSHIFT_PROJECT=homeroom
CLUSTER_SUBDOMAIN=$CLUSTER_SUBDOMAIN
AUTH_USERNAME=*
AUTH_PASSWORD=
EOF

$SCRIPTS_DIR/deploy-personal.sh --settings=katacoda

echo "### Creating route for Homeroom access."

oc expose svc/workshop --name homeroom

echo "### Homeroom Ready."
