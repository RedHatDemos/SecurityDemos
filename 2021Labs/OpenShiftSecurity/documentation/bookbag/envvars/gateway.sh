#!/bin/sh

# The default terminal tab includes a single terminal.
# The TERMINAL_TAB variable may be configured with the following values:
#
#   split   - Split for two vertically stacked terminals
#   split/2 - Split twice for three vertically stacked terminals
#
#export TERMINAL_TAB='split'

# Disable OpenShift Console, this is not appropriate for Red Hat Summit as it
# would point to the wrong cluster.
#export CONSOLE_URL='http://0.0.0.0:10083'

# Enable the following line to disable the right-hand pane entirely.
# Only use this if you have no terminal, no slides, and no console.
#export DEFAULT_PAGE='workshop'

# Flags to explicitly enable/disable specific components
#ENABLE_CONSOLE='false'
#ENABLE_DASHBOARD='false'
#ENABLE_SLIDES='false'
#ENABLE_TERMINAL='false'
#ENABLE_WEBDAV='false'
#ENABLE_WORKSHOP='true'
