#!/bin/bash

SCRIPTS_DIR=`dirname $0`

. $SCRIPTS_DIR/parse-arguments.sh

. $SCRIPTS_DIR/setup-environment.sh

echo "### Delete project resources."

APPLICATION_LABELS="app=$SPAWNER_APPLICATION-$PROJECT_NAME,spawner=$SPAWNER_MODE"

PROJECT_RESOURCES="services,routes,deploymentconfigs,imagestreams,secrets,configmaps,serviceaccounts,rolebindings,serviceaccounts,rolebindings,persistentvolumeclaims,pods"

oc delete "$PROJECT_RESOURCES" -n "$PROJECT_NAME" --selector "$APPLICATION_LABELS"

echo "### Delete global resources."

CLUSTER_RESOURCES="clusterrolebindings,clusterroles"

oc delete "$CLUSTER_RESOURCES" -n "$PROJECT_NAME" --selector "$APPLICATION_LABELS"

if [ x"$PREPULL_IMAGES" == x"true" ]; then
    echo "### Delete daemon set for pre-pulling images."

    oc delete daemonset/$WORKSHOP_NAME-prepull -n "$PROJECT_NAME"
fi
