#!/bin/bash
podman build -t lab-sample-workshop .
podman run -e WORKSHOP_VARS="`cat workshop-vars.json`" --rm -p 10080:10080 lab-sample-workshop
