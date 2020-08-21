#!/bin/bash

SCRIPTS_DIR=`dirname $0`

. $SCRIPTS_DIR/parse-arguments.sh

. $SCRIPTS_DIR/setup-environment.sh

TEMPLATE_REPO=https://raw.githubusercontent.com/$DASHBOARD_REPO

TEMPLATE_FILE=$DASHBOARD_VARIANT.json

if [ x"$DASHBOARD_MODE" != x"" ]; then
    TEMPLATE_FILE=$DASHBOARD_VARIANT-$DASHBOARD_MODE.json
fi

TEMPLATE_PATH=$TEMPLATE_REPO/$DASHBOARD_VERSION/templates/$TEMPLATE_FILE

echo "### Install static resource definitions."

if [ -d $WORKSHOP_DIR/resources/ ]; then
    oc apply -n "$PROJECT_NAME" -f $WORKSHOP_DIR/resources/ --recursive

    if [ "$?" != "0" ]; then
        fail "Failed to create static resource definitions."
        exit 1
    fi
fi

echo "### Creating workshop deployment."

TEMPLATE_ARGS=""

TEMPLATE_ARGS="$TEMPLATE_ARGS --param APPLICATION_NAME=$DASHBOARD_APPLICATION"
TEMPLATE_ARGS="$TEMPLATE_ARGS --param TERMINAL_IMAGE=$WORKSHOP_IMAGE"
TEMPLATE_ARGS="$TEMPLATE_ARGS --param DOWNLOAD_URL=$DOWNLOAD_URL"
TEMPLATE_ARGS="$TEMPLATE_ARGS --param WORKSHOP_FILE=$WORKSHOP_FILE"
TEMPLATE_ARGS="$TEMPLATE_ARGS --param WORKSHOP_ENVVARS=$WORKSHOP_ENVVARS"

if [ x"$DASHBOARD_MODE" == x"" ]; then
    TEMPLATE_ARGS="$TEMPLATE_ARGS --param AUTH_USERNAME=$AUTH_USERNAME"

    if [ ! -z ${AUTH_USERNAME+x} ]; then
        TEMPLATE_ARGS="$TEMPLATE_ARGS --param AUTH_PASSWORD=$AUTH_PASSWORD"
    fi

    TEMPLATE_ARGS="$TEMPLATE_ARGS --param GATEWAY_ENVVARS=$GATEWAY_ENVVARS"
    TEMPLATE_ARGS="$TEMPLATE_ARGS --param TERMINAL_ENVVARS=$TERMINAL_ENVVARS"
    TEMPLATE_ARGS="$TEMPLATE_ARGS --param CONSOLE_IMAGE=$CONSOLE_IMAGE"
    TEMPLATE_ARGS="$TEMPLATE_ARGS --param CLUSTER_SUBDOMAIN=$CLUSTER_SUBDOMAIN"
    TEMPLATE_ARGS="$TEMPLATE_ARGS --param OPENSHIFT_PROJECT=$OPENSHIFT_PROJECT"
    TEMPLATE_ARGS="$TEMPLATE_ARGS --param OPENSHIFT_USERNAME=$OPENSHIFT_USERNAME"
    TEMPLATE_ARGS="$TEMPLATE_ARGS --param OPENSHIFT_PASSWORD=$OPENSHIFT_PASSWORD"
fi

if [ x"$DASHBOARD_MODE" == x"cluster-admin" ]; then
    TEMPLATE_ARGS="$TEMPLATE_ARGS --param AUTH_USERNAME=$AUTH_USERNAME"

    if [ ! -z ${AUTH_USERNAME+x} ]; then
        TEMPLATE_ARGS="$TEMPLATE_ARGS --param AUTH_PASSWORD=$AUTH_PASSWORD"
    fi

    TEMPLATE_ARGS="$TEMPLATE_ARGS --param GATEWAY_ENVVARS=$GATEWAY_ENVVARS"
    TEMPLATE_ARGS="$TEMPLATE_ARGS --param TERMINAL_ENVVARS=$TERMINAL_ENVVARS"
    TEMPLATE_ARGS="$TEMPLATE_ARGS --param CONSOLE_IMAGE=$CONSOLE_IMAGE"
    TEMPLATE_ARGS="$TEMPLATE_ARGS --param PROJECT_NAME=$PROJECT_NAME"
    TEMPLATE_ARGS="$TEMPLATE_ARGS --param CLUSTER_SUBDOMAIN=$CLUSTER_SUBDOMAIN"
    TEMPLATE_ARGS="$TEMPLATE_ARGS --param OPENSHIFT_PROJECT=$OPENSHIFT_PROJECT"
fi

oc process -n "$PROJECT_NAME" -f $TEMPLATE_PATH $TEMPLATE_ARGS | \
    oc apply -n "$PROJECT_NAME" -f -

if [ "$?" != "0" ]; then
    fail "Failed to create deployment for dashboard."
    exit 1
fi

echo "### Waiting for the dashboard to deploy."

oc rollout status dc/"$DASHBOARD_APPLICATION" -n "$PROJECT_NAME"

if [ "$?" != "0" ]; then
    fail "Deployment of dashboard failed to complete."
    exit 1
fi

echo "### Waiting for the dashboard to deploy."

oc rollout status dc/"$DASHBOARD_APPLICATION" -n "$PROJECT_NAME"

if [ "$?" != "0" ]; then
    fail "Deployment of dashboard failed to complete."
    exit 1
fi

echo "### Route details for the dashboard are as follows."

oc get route "${DASHBOARD_APPLICATION}" -n "$PROJECT_NAME" \
    -o template --template '{{.spec.host}}{{"\n"}}'
