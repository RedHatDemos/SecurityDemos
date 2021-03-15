fail()
{
    echo "Error:" $* 1>&2
    exit 1
}

warn()
{
    echo "Warning:" $* 1>&2
}

trim()
{
    local trimmed="$1"

    # Strip leading space.
    trimmed="${trimmed## }"
    # Strip trailing space.
    trimmed="${trimmed%% }"

    echo "$trimmed"
}

SCRIPTS_DIR=`dirname $0`
WORKSHOP_DIR=`dirname $SCRIPTS_DIR`
SOURCE_DIR=`dirname $WORKSHOP_DIR`

REPOSITORY_NAME=`basename $SOURCE_DIR`

if [ `basename $WORKSHOP_DIR` != ".workshop" ]; then
    fail "Failed to find workshop directory."
    exit 1
fi

echo "### Reading the default configuration."

. $SCRIPTS_DIR/default-settings.sh

echo "### Reading the workshop configuration."

if [ ! -f $WORKSHOP_DIR/settings.sh ]; then
    warn "Cannot find any workshop settings."
else
    . $WORKSHOP_DIR/settings.sh
fi

if [ x"$SETTINGS_NAME" != x"" ]; then
    if [ ! -f $WORKSHOP_DIR/$SETTINGS_NAME-settings.sh ]; then
        warn "Cannot find any custom workshop settings."
    else
        . $WORKSHOP_DIR/$SETTINGS_NAME-settings.sh
    fi
fi

for key in "${overrides[@]}"; do
    case $key in
        @*)
            file="${key#*@}"
            if [ -f "$file" ]; then
                . $file
            fi
            ;;
        *)
            mapped_key="override_${key}"
            value="${!mapped_key}"
            declare ${key}="${value}"
            ;;
    esac
done

if [ x"$WORKSHOP_IMAGE" == x"" ]; then
    WORKSHOP_IMAGE=$DASHBOARD_IMAGE
fi

if [ -f "$WORKSHOP_DIR/jupyterhub_config.py" ]; then
    JUPYTERHUB_CONFIG=`cat $WORKSHOP_DIR/jupyterhub_config.py`
fi

if [ -f "$WORKSHOP_DIR/jupyterhub_config.sh" ]; then
    JUPYTERHUB_ENVVARS=`cat $WORKSHOP_DIR/jupyterhub_config.sh`
fi

if [ -f "$WORKSHOP_DIR/terminal.sh" ]; then
    TERMINAL_ENVVARS=`cat $WORKSHOP_DIR/terminal.sh`
fi

if [ -f "$WORKSHOP_DIR/workshop.sh" ]; then
    WORKSHOP_ENVVARS=`cat $WORKSHOP_DIR/workshop.sh`
fi

if [ -f "$WORKSHOP_DIR/gateway.sh" ]; then
    GATEWAY_ENVVARS=`cat $WORKSHOP_DIR/gateway.sh`
fi

echo "### Setting the workshop application."

WORKSHOP_NAME=${WORKSHOP_NAME:-$REPOSITORY_NAME}

SPAWNER_APPLICATION=${SPAWNER_APPLICATION:-$WORKSHOP_NAME}
DASHBOARD_APPLICATION=${DASHBOARD_APPLICATION:-$WORKSHOP_NAME}

if [ x"$PROJECT_NAME" == x"" ]; then
    PROJECT_NAME=`oc project --short 2>/dev/null`
fi

if [ x"$PROJECT_NAME" == x"" ]; then
    fail "Cannot determine name of project."
    exit 1
fi

oc get project "$PROJECT_NAME" > /dev/null 2>&1

if [ "$?" != "0" ]; then
    fail "Project $PROJECT_NAME does not exist."
    exit 1
fi
