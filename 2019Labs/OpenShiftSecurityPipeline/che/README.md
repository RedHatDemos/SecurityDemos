# Scripts

Scripts and configuratoin used to deploy eclipse che on OpenShift. Refer to README.adoc for more detailed information.

Che will be deployed into the `che-workspaces` openshift project using the following command:

        ./deploy.sh -d -p=che-workspaces

An instance of `postgresql` and Red Hat SSO will also be deployed to support integration with OpenShift oauth

The following images are required to deploy the eclipse che:

  * registry.access.redhat.com/redhat-sso-7/sso72-openshift:1.2-8
  * registry.access.redhat.com/rhscl/postgresql-96-rhel7:1-25
  * registry.access.redhat.com/codeready-workspaces/server:latest
  * registry.access.redhat.com/codeready-workspaces/server-operator:latest
  * registry.access.redhat.com/codeready-workspaces/stacks-python:latest
  * registry.access.redhat.com/codeready-workspaces/stacks-java:latest

Two 10Gi PVs will also need to be available
