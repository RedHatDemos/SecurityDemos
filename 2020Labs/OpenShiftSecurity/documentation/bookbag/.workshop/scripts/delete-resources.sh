#!/bin/bash

SCRIPTS_DIR=`dirname $0`

. $SCRIPTS_DIR/setup-environment.sh

echo "### Delete extra resources."

if [ -d $WORKSHOP_DIR/resources/ ]; then
    oc delete -f $WORKSHOP_DIR/resources/ --recursive
fi
