#!/bin/bash

# Default Conda environment name value
# NOTE: It is possible to chain-load environments by passing more than one
# environment name
CONDA_ENVIRONMENT_NAME=("test-env-1")

# The '--name' parameter of getopt is used to set the program name that appears
# in diagnostic messages when an error occurs.  The name of this script will be
# passed as an argument to that parameter.
SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}" .sh)"
# Backup OPTIND if it was previously set
if [ -v OPTIND ]; then
    OPTIND_BAK="$OPTIND"
    OPTIND=1
fi

# Parse script options
while ( getopt -o "n:" -l "name:" --name "$SCRIPT_NAME" -- "$@" > /dev/null ) && [[ $OPTIND -le $# ]]
do
    # OPTIND is a special variable set during the call to getopt referring to
    # the option index
    # NOTE: OPTARG variable is only set by 'getopts'--not by 'getopt'
    case "${!OPTIND}" in
        -n | --name)
            # Clear environments variable to prepare it for population
            CONDA_ENVIRONMENT_NAME=()

            # Point to the first argument after the parameter identifier
            OPTIND=$((OPTIND + 1))

            # Iterate over arguments following the parameter that do not start a
            # new parameter definition
            while [[ $OPTIND -le $# ]] && [[ ${!OPTIND:0:1} != - ]]; do
                CONDA_ENVIRONMENT_NAME+=("${!OPTIND}")
                OPTIND=$((OPTIND + 1))
            done
            ;;
        \?)
            # opt = '?' for an unknown option
            # NOTE: The leading ':' 'silences' errors, allowing them to be
            # custom-handled here instead
            echo "Unknown option: ${!OPTIND}" >&2
            OPTIND=$((OPTIND + 1))
            return 1
            ;;
        :)
            # opt = ':' for an option that requires an argument but doesn't
            # have one (as indicated by the leading ":" in ":n:")
            echo "Option ${!OPTIND} requires an argument." >&2
            OPTIND=$((OPTIND + 1))
            return 1
            ;;
        *)
            echo "In catch-all arg ${!OPTIND} ind $OPTIND"
            OPTIND=$((OPTIND + 1))
            break
            ;;
    esac
done

# WARNING: DO NOT USE $PWD in scripts (it returns the calling directory, rather
# than the directory containing the invoked script)
CONDA_BASH_SCRIPTS_DIRECTORY="$(readlink -f $(dirname "$BASH_SOURCE"))"

# Restore former OPTIND value if it was previously set
if [ -v OPTIND_BAK ]; then
    OPTIND="$OPTIND_BAK"
    unset OPTIND_BAK
else
    # Otherwise unset OPTIND
    unset OPTIND
fi

# Prepare conda environment variables
source "${CONDA_BASH_SCRIPTS_DIRECTORY}/Setup_Conda_Environment_Variables.sh"

# Check the exit status
if [ $? -ne 0 ]; then
    echo "'Setup_Conda_Environment_Variables' failed with exit code: $?" >&2
    return $?
fi

if [ ${#CONDA_ENVIRONMENT_NAME[@]} -eq 0 ]; then
    echo "No Conda environments selected"
    return 1
fi

# Activate the specified environment
for element in "${CONDA_ENVIRONMENT_NAME[@]}"
do
    # Activate the corresponding Conda environment
    conda activate "$element"

    # Check the exit status
    if [ $? -ne 0 ]; then
        echo "'conda activate "$element"' failed with exit code: $?" >&2
        return $?
    fi
done

# Enable tab command completions for Conda
# eval "$(register-python-argcomplete conda)"
