#!/bin/bash

CONDA_ROOT_DIRECTORY="$(readlink -f $(dirname "$BASH_SOURCE")/../..)"
CONDA_ENVIRONMENTS_ROOT_DIRECTORY="${CONDA_ROOT_DIRECTORY}/Environments"

# Define conda environments path variable with the appropriate path for this
# repository (if it doesn't exist), or prepend the path to that variable (if the
# variable is not empty)
echo "$CONDA_ENVS_PATH" | grep -q "${CONDA_ENVIRONMENTS_ROOT_DIRECTORY}"

# Check the exit code of grep to determine if the path exists
if [ $? -ne 0 ]; then
    # A non-0 (error) exit code means the path doesn't exist in CONDA_ENVS_PATH,
    # and CONDA_ENVS_PATH will need to be updated to include
    # CONDA_ENVIRONMENTS_ROOT_DIRECTORY
    [[ -z "${CONDA_ENVS_PATH}" ]] \
        && export CONDA_ENVS_PATH="${CONDA_ENVIRONMENTS_ROOT_DIRECTORY}" \
        || export CONDA_ENVS_PATH="${CONDA_ENVIRONMENTS_ROOT_DIRECTORY}:${CONDA_ENVS_PATH}"
else
    # A 0 (success) exit code means the path already exists, and there's nothing
    # to be done
    echo "CONDA_ENVIRONMENTS_ROOT_DIRECTORY already exists in CONDA_ENVS_PATH"
fi

# Define the CONDARC environment variable with the path to the .condarc file
export CONDARC="${CONDA_ROOT_DIRECTORY}/.condarc"

# Enable tab command completions for Conda
# eval "$(register-python-argcomplete conda)"
