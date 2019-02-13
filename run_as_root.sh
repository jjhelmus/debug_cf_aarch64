#!/usr/bin/env bash

# PLEASE NOTE: This script has been automatically generated by conda-smithy. Any changes here
# will be lost next time ``conda smithy rerender`` is run. If you would like to make permanent
# changes to this script, consider a proposal to conda-smithy so that other feedstocks can also
# benefit from the improvement.

set -xeuo pipefail

THISDIR="$( cd "$( dirname "$0" )" >/dev/null && pwd )"
PROVIDER_DIR="$(basename $THISDIR)"

FEEDSTOCK_ROOT=$(cd "$(dirname "$0")/.."; pwd;)

docker info

# In order for the conda-build process in the container to write to the mounted
# volumes, we need to run with the same id as the host machine, which is
# normally the owner of the mounted volumes, or at least has write permission
export HOST_USER_ID=$(id -u)
# Check if docker-machine is being used (normally on OSX) and get the uid from
# the VM
if hash docker-machine 2> /dev/null && docker-machine active > /dev/null; then
    export HOST_USER_ID=$(docker-machine ssh $(docker-machine active) id -u)
fi

#pip install shyaml
#DOCKER_IMAGE="condaforge/linux-anvil-aarch64"
#DOCKER_IMAGE="jjhelmus/debug_cf_aarch64:initial"
DOCKER_IMAGE="jjhelmus/debug_cf_aarch64:qemu_3.1.0"

#mkdir -p "$ARTIFACTS"
#DONE_CANARY="$ARTIFACTS/conda-forge-build-done-${CONFIG}"
#rm -f "$DONE_CANARY"
# Not all providers run with a real tty.  Disable using one
DOCKER_RUN_ARGS=" "

export UPLOAD_PACKAGES="${UPLOAD_PACKAGES:-True}"
docker run --privileged ${DOCKER_RUN_ARGS} \
           -v "${FEEDSTOCK_ROOT}":/home/conda/feedstock_root:rw,z \
           $DOCKER_IMAGE \
           /home/conda/feedstock_root/${PROVIDER_DIR}/build_steps_root.sh

# verify that the end of the script was reached
#test -f "$DONE_CANARY"
