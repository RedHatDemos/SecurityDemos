echo "### Parsing command line arguments."

overrides=()

while [[ $# -gt 0 ]]
do
    i="$1"
    case $i in
        --event=*|--settings=*)
            SETTINGS_NAME="${i#*=}"
            shift
            ;;
        --event|--settings)
            shift
            SETTINGS_NAME="$1"
            shift
            ;;
        --project=*)
            PROJECT_NAME="${i#*=}"
            shift
            ;;
        --project)
            shift
            PROJECT_NAME="$1"
            shift
            ;;
        --override=@*)
            overrides+=(${i#*=})
            shift
            ;;
        --override=*)
            p="${i#*=}"
            key=${p%%=*}
            value=${p#*=}
            mapped_key=override_${key}
            declare ${mapped_key}="$value"
            overrides+=(${key})
            shift
            ;;
        --override)
            shift
            i="$1"
            case $1 in
                @*)
                    overrides+=($i)
                    ;;
                *)
                    key=${i%%=*}
                    value=${i#*=}
                    mapped_key=override_${key}
                    declare ${mapped_key}="$value"
                    overrides+=(${key})
                    ;;
            esac
            shift
            ;;
        *)
            shift
            ;;
    esac
done
