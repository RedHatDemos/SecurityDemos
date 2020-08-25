Workshop Scripts
================

This repository contains scripts to help with deploying and building workshops. It should be added as a Git submodule at the location ``.workshop/scripts`` of a Git repository for a workshop.

Adding the Sub Module
---------------------

To add this Git repository as a Git submodule to an existing Git repository for a workshop, run:

```
git submodule add -b stable/1.x https://github.com/openshift-homeroom/spawner-scripts.git .workshop/scripts
```

Once added as a Git submodule, to pull the source code for it, run:

```
git submodule update --remote
```

Configuring Deployments
-----------------------

To configure the deployments created by the scripts, create in your Git repository the file ``.workshop/settings.sh``. In this file, you need to set the name of the workshop, the location of any pre-built image for the workshop if one exists, and other appropriate settings to control the workshop spawner.

```
WORKSHOP_NAME=lab-markdown-sample
WORKSHOP_IMAGE=quay.io/openshifthomeroom/lab-markdown-sample:master
RESOURCE_BUDGET=medium
MAX_SESSION_AGE=3600
IDLE_TIMEOUT=300
```

Deploying the Spawner
----------------------

To deploy the spawner for the workshop, create a project in OpenShift into which the workshop is to be deployed.

```
oc new-project workshops
```

From within the top level of your Git repository that you added this Git repository as a submodule, you can now run:

```
.workshop/scripts/deploy-spawner.sh
```

You must be a cluster admin to be able to deploy the workshop using the spawner.

The name of the deployment will be dictated by the value of ``WORKSHOP_NAME`` in the ``.workshop/settings.sh`` file.

Building the Workshop
---------------------

The deployment created above will use the declared pre-existing image for the workshop, or an empty workshop image if none is provided.

To deploy the workshop content from your Git repository, or make changes to the workshop content and test them, run:

```
.workshop/scripts/build-workshop.sh
```

This will replace the existing image used by the active deployment.

If you are running an existing instance of the workshop, from your web browser select "Restart Workshop" from the menu top right of the workshop environment dashboard.

When you are happy with your changes, push them back to the remote Git repository.

If you need to change the RBAC definitions, or what resources are created when a project is created, change the definitions in the ``resources`` and ``templates`` directory if you have them. You can then re-run:

```
.workshop/scripts/deploy-spawner.sh
```

and it will update the active definitions.

Note that if you do this, you will need to re-run:

```
.workshop/scripts/build-workshop.sh
```

to have any local content changes be used once again as it will revert back to using the original image for the workshop.

Deleting the Workshop
---------------------

To delete the spawner and any active sessions, run:

```
.workshop/scripts/delete-spawner.sh
```

To delete the build configuration for the workshop image, run:

```
.workshop/scripts/delete-workshop.sh
```

To delete any special resources for CRDs and cluster roles, run:

```
.workshop/scripts/delete-resources.sh
```

Personal Deployment
-------------------

If you don't want to deploy the workshop for multiple users, you can instead deploy a single instance of the workshop.

To do this, ensure that you have first deleted any spawner deployment created using the commands above.

Then run:

```
.workshop/scripts/deploy-personal.sh
```

You do not need to be cluster admin to deploy a single instance of the workshop.

If you need to deploy the workshop from the local content, as for when using the spawner, run:

```
.workshop/scripts/build-workshop.sh
```

You do not need to force a re-deployment as it will happen automatically.

To delete the workshop instance run:

```
.workshop/scripts/delete-personal.sh
```

Also run the scripts to delete the build configuration and resources.
