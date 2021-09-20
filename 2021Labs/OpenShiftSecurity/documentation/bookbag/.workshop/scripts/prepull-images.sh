#!/bin/bash

SCRIPTS_DIR=`dirname $0`

. $SCRIPTS_DIR/parse-arguments.sh

. $SCRIPTS_DIR/setup-environment.sh

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
    fail "Creation of daemonset to pre-pull images failed."
    exit 1
fi
