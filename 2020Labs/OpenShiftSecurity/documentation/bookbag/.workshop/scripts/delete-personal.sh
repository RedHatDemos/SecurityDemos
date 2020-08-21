#!/bin/bash

SCRIPTS_DIR=`dirname $0`

. $SCRIPTS_DIR/parse-arguments.sh

. $SCRIPTS_DIR/setup-environment.sh

echo "### Delete project resources."

APPLICATION_LABELS="app=$DASHBOARD_APPLICATION"

PROJECT_RESOURCES="all,serviceaccount,rolebinding,configmap"

oc delete "$PROJECT_RESOURCES" -n "$PROJECT_NAME" --selector "$APPLICATION_LABELS"
