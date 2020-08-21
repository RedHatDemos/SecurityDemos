#!/bin/bash

SCRIPTS_DIR=`dirname $0`

. $SCRIPTS_DIR/parse-arguments.sh

. $SCRIPTS_DIR/setup-environment.sh

TEMPLATE_REPO=https://raw.githubusercontent.com/$SPAWNER_REPO
TEMPLATE_FILE=$SPAWNER_MODE-$SPAWNER_VARIANT.json
TEMPLATE_PATH=$TEMPLATE_REPO/$SPAWNER_VERSION/templates/$TEMPLATE_FILE

echo "### Checking spawner configuration."

if [[ "$SPAWNER_MODE" =~ ^(hosted-workshop|terminal-server)$ ]]; then
    if [ x"$CLUSTER_SUBDOMAIN" == x"" ]; then
        oc create route edge -n "$PROJECT_NAME" $WORKSHOP_NAME-dummy \
            --service dummy --port 8080 > /dev/null 2>&1

        if [ "$?" != "0" ]; then
            fail "Cannot create dummy route $WORKSHOP_NAME-dummy."
        fi

        DUMMY_FQDN=`oc get route/$WORKSHOP_NAME-dummy -n "$PROJECT_NAME" -o template --template {{.spec.host}}`

        if [ "$?" != "0" ]; then
            fail "Cannot determine host from dummy route."
        fi

        DUMMY_HOST=$WORKSHOP_NAME-dummy-$PROJECT_NAME
        CLUSTER_SUBDOMAIN=`echo $DUMMY_FQDN | sed -e "s/^$DUMMY_HOST.//"`

        if [ x"$CLUSTER_SUBDOMAIN" == x"$DUMMY_FQDN" ]; then
            CLUSTER_SUBDOMAIN=""
        fi

        oc delete route $WORKSHOP_NAME-dummy -n "$PROJECT_NAME" > /dev/null 2>&1

        if [ "$?" != "0" ]; then
            warn "Cannot delete dummy route."
        fi
    fi

    if [ x"$CLUSTER_SUBDOMAIN" == x"" ]; then
        read -p "CLUSTER_SUBDOMAIN: " CLUSTER_SUBDOMAIN

        CLUSTER_SUBDOMAIN=$(trim $CLUSTER_SUBDOMAIN)

        if [ x"$CLUSTER_SUBDOMAIN" == x"" ]; then
            fail "Must provide valid CLUSTER_SUBDOMAIN."
        fi
    fi
fi

if [ x"$CLEAN_INSTALL" == x"true" ]; then
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
fi

if [ x"$PREPULL_IMAGES" == x"true" ]; then
    echo "### Deploy daemon set to pre-pull images."

    cat << EOF | oc apply -n "$PROJECT_NAME" -f -
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: $WORKSHOP_NAME-prepull
spec:
  selector:
    matchLabels:
      app: $WORKSHOP_NAME-prepull
  template:
    metadata:
      labels:
        app: $WORKSHOP_NAME-prepull
    spec:
      initContainers:
      - name: prepull-spawner 
        image: $SPAWNER_IMAGE
        command: ["/bin/true"]
        resources:
          limits:
            memory: 128Mi
      - name: prepull-terminal 
        image: $TERMINAL_IMAGE
        command: ["/bin/true"]
        resources:
          limits:
            memory: 128Mi
          requests:
            memory: 128Mi
      - name: prepull-workshop 
        image: $WORKSHOP_IMAGE
        command: ["/bin/true"]
        resources:
          limits:
            memory: 128Mi
          requests:
            memory: 128Mi
      - name: prepull-console
        image: $CONSOLE_IMAGE
        command: ["/bin/true"]
        resources:
          limits:
            memory: 128Mi
          requests:
            memory: 128Mi
      containers:
      - name: pause
        image: gcr.io/google_containers/pause
        resources:
          limits:
            memory: 128Mi
          requests:
            memory: 128Mi
EOF

    if [ "$?" != "0" ]; then
        warn "Creation of daemonset to pre-pull images failed."
    fi
fi

echo "### Creating spawner application."

if [ x"$SPAWNER_MODE" == x"learning-portal" ]; then
    oc process -n "$PROJECT_NAME" -f $TEMPLATE_PATH \
        --param PROJECT_NAME="$PROJECT_NAME" \
        --param APPLICATION_NAME="$SPAWNER_APPLICATION" \
        --param HOMEROOM_NAME="$HOMEROOM_NAME" \
        --param HOMEROOM_LINK="$HOMEROOM_LINK" \
        --param WORKSHOP_TITLE="$WORKSHOP_TITLE" \
        --param WORKSHOP_DESCRIPTION="$WORKSHOP_DESCRIPTION" \
        --param SPAWNER_IMAGE="$SPAWNER_IMAGE" \
        --param CONSOLE_IMAGE="$CONSOLE_IMAGE" \
        --param DOWNLOAD_URL="$DOWNLOAD_URL" \
        --param SPAWNER_ROLE="$SPAWNER_ROLE" \
        --param SPAWNER_PASSWORD="$SPAWNER_PASSWORD" \
        --param WORKSHOP_FILE="$WORKSHOP_FILE" \
        --param WORKSHOP_MEMORY="$WORKSHOP_MEMORY" \
        --param RESOURCE_BUDGET="$RESOURCE_BUDGET" \
        --param SERVER_LIMIT="$SERVER_LIMIT" \
        --param MAX_SESSION_AGE="$MAX_SESSION_AGE" \
        --param GATEWAY_ENVVARS="$GATEWAY_ENVVARS" \
        --param TERMINAL_ENVVARS="$TERMINAL_ENVVARS" \
        --param WORKSHOP_ENVVARS="$WORKSHOP_ENVVARS" \
        --param IDLE_TIMEOUT="$IDLE_TIMEOUT" \
        --param JUPYTERHUB_CONFIG="$JUPYTERHUB_CONFIG" \
        --param JUPYTERHUB_ENVVARS="$JUPYTERHUB_ENVVARS" \
        --param LETS_ENCRYPT="$LETS_ENCRYPT" \
        | oc apply -n "$PROJECT_NAME" -f -
fi

if [ x"$SPAWNER_MODE" == x"user-workspace" ]; then
    oc process -n "$PROJECT_NAME" -f $TEMPLATE_PATH \
        --param PROJECT_NAME="$PROJECT_NAME" \
        --param APPLICATION_NAME="$SPAWNER_APPLICATION" \
        --param HOMEROOM_NAME="$HOMEROOM_NAME" \
        --param HOMEROOM_LINK="$HOMEROOM_LINK" \
        --param WORKSHOP_TITLE="$WORKSHOP_TITLE" \
        --param WORKSHOP_DESCRIPTION="$WORKSHOP_DESCRIPTION" \
        --param SPAWNER_IMAGE="$SPAWNER_IMAGE" \
        --param CONSOLE_IMAGE="$CONSOLE_IMAGE" \
        --param DOWNLOAD_URL="$DOWNLOAD_URL" \
        --param WORKSHOP_FILE="$WORKSHOP_FILE" \
        --param WORKSHOP_MEMORY="$WORKSHOP_MEMORY" \
        --param RESOURCE_BUDGET="$RESOURCE_BUDGET" \
        --param GATEWAY_ENVVARS="$GATEWAY_ENVVARS" \
        --param TERMINAL_ENVVARS="$TERMINAL_ENVVARS" \
        --param WORKSHOP_ENVVARS="$WORKSHOP_ENVVARS" \
        --param IDLE_TIMEOUT="$IDLE_TIMEOUT" \
        --param JUPYTERHUB_CONFIG="$JUPYTERHUB_CONFIG" \
        --param JUPYTERHUB_ENVVARS="$JUPYTERHUB_ENVVARS" \
        --param LETS_ENCRYPT="$LETS_ENCRYPT" \
        | oc apply -n "$PROJECT_NAME" -f -
fi

if [ x"$SPAWNER_MODE" == x"hosted-workshop" ]; then
    oc process -n "$PROJECT_NAME" -f $TEMPLATE_PATH \
        --param PROJECT_NAME="$PROJECT_NAME" \
        --param APPLICATION_NAME="$SPAWNER_APPLICATION" \
        --param HOMEROOM_NAME="$HOMEROOM_NAME" \
        --param HOMEROOM_LINK="$HOMEROOM_LINK" \
        --param WORKSHOP_TITLE="$WORKSHOP_TITLE" \
        --param WORKSHOP_DESCRIPTION="$WORKSHOP_DESCRIPTION" \
        --param SPAWNER_IMAGE="$SPAWNER_IMAGE" \
        --param CONSOLE_IMAGE="$CONSOLE_IMAGE" \
        --param DOWNLOAD_URL="$DOWNLOAD_URL" \
        --param WORKSHOP_FILE="$WORKSHOP_FILE" \
        --param WORKSHOP_MEMORY="$WORKSHOP_MEMORY" \
        --param GATEWAY_ENVVARS="$GATEWAY_ENVVARS" \
        --param TERMINAL_ENVVARS="$TERMINAL_ENVVARS" \
        --param WORKSHOP_ENVVARS="$WORKSHOP_ENVVARS" \
        --param CLUSTER_SUBDOMAIN="$CLUSTER_SUBDOMAIN" \
        --param IDLE_TIMEOUT="$IDLE_TIMEOUT" \
        --param JUPYTERHUB_CONFIG="$JUPYTERHUB_CONFIG" \
        --param JUPYTERHUB_ENVVARS="$JUPYTERHUB_ENVVARS" \
        --param LETS_ENCRYPT="$LETS_ENCRYPT" \
        | oc apply -n "$PROJECT_NAME" -f -
fi

if [ x"$SPAWNER_MODE" == x"terminal-server" ]; then
    oc process -n "$PROJECT_NAME" -f $TEMPLATE_PATH \
        --param PROJECT_NAME="$PROJECT_NAME" \
        --param APPLICATION_NAME="$SPAWNER_APPLICATION" \
        --param HOMEROOM_NAME="$HOMEROOM_NAME" \
        --param HOMEROOM_LINK="$HOMEROOM_LINK" \
        --param WORKSHOP_TITLE="$WORKSHOP_TITLE" \
        --param WORKSHOP_DESCRIPTION="$WORKSHOP_DESCRIPTION" \
        --param SPAWNER_IMAGE="$SPAWNER_IMAGE" \
        --param CONSOLE_IMAGE="$CONSOLE_IMAGE" \
        --param DOWNLOAD_URL="$DOWNLOAD_URL" \
        --param WORKSHOP_FILE="$WORKSHOP_FILE" \
        --param WORKSHOP_MEMORY="$WORKSHOP_MEMORY" \
        --param GATEWAY_ENVVARS="$GATEWAY_ENVVARS" \
        --param TERMINAL_ENVVARS="$TERMINAL_ENVVARS" \
        --param WORKSHOP_ENVVARS="$WORKSHOP_ENVVARS" \
        --param CLUSTER_SUBDOMAIN="$CLUSTER_SUBDOMAIN" \
        --param IDLE_TIMEOUT="$IDLE_TIMEOUT" \
        --param JUPYTERHUB_CONFIG="$JUPYTERHUB_CONFIG" \
        --param JUPYTERHUB_ENVVARS="$JUPYTERHUB_ENVVARS" \
        --param LETS_ENCRYPT="$LETS_ENCRYPT" \
        | oc apply -n "$PROJECT_NAME" -f -
fi

if [ x"$SPAWNER_MODE" == x"jumpbox-server" ]; then
    oc process -n "$PROJECT_NAME" -f $TEMPLATE_PATH \
        --param PROJECT_NAME="$PROJECT_NAME" \
        --param APPLICATION_NAME="$SPAWNER_APPLICATION" \
        --param SPAWNER_IMAGE="$SPAWNER_IMAGE" \
        --param DOWNLOAD_URL="$DOWNLOAD_URL" \
        --param WORKSHOP_FILE="$WORKSHOP_FILE" \
        --param WORKSHOP_MEMORY="$WORKSHOP_MEMORY" \
        --param GATEWAY_ENVVARS="$GATEWAY_ENVVARS" \
        --param TERMINAL_ENVVARS="$TERMINAL_ENVVARS" \
        --param WORKSHOP_ENVVARS="$WORKSHOP_ENVVARS" \
        --param IDLE_TIMEOUT="$IDLE_TIMEOUT" \
        --param JUPYTERHUB_CONFIG="$JUPYTERHUB_CONFIG" \
        --param JUPYTERHUB_ENVVARS="$JUPYTERHUB_ENVVARS" \
        --param LETS_ENCRYPT="$LETS_ENCRYPT" \
        | oc apply -n "$PROJECT_NAME" -f -
fi

if [ "$?" != "0" ]; then
    fail "Failed to create deployment for spawner."
    exit 1
fi

echo "### Waiting for the spawner to deploy."

oc rollout status dc/"$SPAWNER_APPLICATION" -n "$PROJECT_NAME"

if [ "$?" != "0" ]; then
    fail "Deployment of spawner failed to complete."
    exit 1
fi

echo "### Install static resource definitions."

if [ -d $WORKSHOP_DIR/resources/ ]; then
    oc apply -n "$PROJECT_NAME" -f $WORKSHOP_DIR/resources/ --recursive

    if [ "$?" != "0" ]; then
        fail "Failed to create static resource definitions."
        exit 1
    fi
fi

echo "### Update spawner configuration for workshop."

if [ -f $WORKSHOP_DIR/templates/clusterroles-session-rules.yaml ]; then
    oc process -n "$PROJECT_NAME" \
        -f $WORKSHOP_DIR/templates/clusterroles-session-rules.yaml \
        --param SPAWNER_APPLICATION="$SPAWNER_APPLICATION" \
        --param SPAWNER_NAMESPACE="$PROJECT_NAME" | \
        oc apply -n "$PROJECT_NAME" -f -

    if [ "$?" != "0" ]; then
        fail "Failed to update session rules for workshop."
        exit 1
    fi
fi

if [ -f $WORKSHOP_DIR/templates/clusterroles-spawner-rules.yaml ]; then
    oc process -n "$PROJECT_NAME" \
        -f $WORKSHOP_DIR/templates/clusterroles-spawner-rules.yaml \
        --param SPAWNER_APPLICATION="$SPAWNER_APPLICATION" \
        --param SPAWNER_NAMESPACE="$PROJECT_NAME" | \
        oc apply -n "$PROJECT_NAME" -f -

    if [ "$?" != "0" ]; then
        fail "Failed to update spawner rules for workshop."
        exit 1
    fi
fi

if [ -f $WORKSHOP_DIR/templates/configmap-extra-resources.yaml ]; then
    oc process -n "$PROJECT_NAME" \
        -f $WORKSHOP_DIR/templates/configmap-extra-resources.yaml \
        --param SPAWNER_APPLICATION="$SPAWNER_APPLICATION" \
        --param SPAWNER_NAMESPACE="$PROJECT_NAME" | \
        oc apply -n "$PROJECT_NAME" -f -

    if [ "$?" != "0" ]; then
        fail "Failed to update extra resources for workshop."
        exit 1
    fi
fi

echo "### Updating spawner to use image for workshop."

oc tag "$WORKSHOP_IMAGE" "$SPAWNER_APPLICATION:latest" -n "$PROJECT_NAME"

if [ "$?" != "0" ]; then
    fail "Failed to update spawner to use workshop image."
    exit 1
fi

echo "### Restart the spawner with new configuration."

oc rollout latest dc/"$SPAWNER_APPLICATION" -n "$PROJECT_NAME"

if [ "$?" != "0" ]; then
    fail "Failed to restart the spawner."
    exit 1
fi

echo "### Waiting for the spawner to deploy again."

oc rollout status dc/"$SPAWNER_APPLICATION" -n "$PROJECT_NAME"

if [ "$?" != "0" ]; then
    fail "Deployment of spawner failed to complete."
    exit 1
fi

echo "### Route details for the spawner are as follows."

oc get route "${SPAWNER_APPLICATION}" -n "$PROJECT_NAME" \
    -o template --template '{{.spec.host}}{{"\n"}}'
