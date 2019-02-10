#!/usr/bin/env bash

# PLEASE NOTE: This script has been automatically generated by conda-smithy. Any changes here
# will be lost next time ``conda smithy rerender`` is run. If you would like to make permanent
# changes to this script, consider a proposal to conda-smithy so that other feedstocks can also
# benefit from the improvement.

set -Exeuo pipefail

# debugging
echo "I AM ROOT"
whoami
lscpu
uname -a

# create conda user
USER_ID=1001
useradd --shell /bin/bash -u $USER_ID -G lucky -o -c "" -m conda

# 
readelf -h /usr/bin/sudo
/usr/bin/sudo -l -U conda
cat /etc/sudoers

echo "Debug sudo /var/log/sudo_debug.log all@debug" >> /etc/sudo.conf
echo "Debug sudoers.so /var/log/sudo_debug.log all@debug" >> /etc/sudo.conf
cat /etc/sudo.conf

# run command as conda user
echo "I AM CONDA"
/opt/conda/bin/su-exec conda whoami || true
/opt/conda/bin/su-exec conda "/usr/bin/sudo" -h || true
/opt/conda/bin/su-exec conda "/usr/bin/sudo" -l -U conda || true
/opt/conda/bin/su-exec conda ls -l /usr/bin/sudo || true
#/opt/conda/bin/su-exec conda "/usr/bin/sudo" yum install -y libX11-devel || true

# back as root
echo "I AM ROOT"
whoami
cat /var/log/sudo_debug.log
#exec /opt/conda/bin/su-exec conda /usr/bin/sudo yum install -y libX11-devel
exit 9






#conda info
#file /usr/bin/sudo
echo "Running sudo"
readelf -h /usr/bin/sudo
/usr/bin/sudo -l -U conda
echo "I AM ROOT"
/usr/bin/sudo yum install -y libX11-devel
echo "Done with sudo"
exit 9

# Normal
export PYTHONUNBUFFERED=1
export FEEDSTOCK_ROOT=/home/conda/feedstock_root
export RECIPE_ROOT=/home/conda/recipe_root
export CI_SUPPORT=/home/conda/feedstock_root/.ci_support
#export CONFIG_FILE="${CI_SUPPORT}/${CONFIG}.yaml"

cat >~/.condarc <<CONDARC

conda-build:
 root-dir: /home/conda/feedstock_root/build_artifacts

CONDARC




conda install --yes --quiet conda-forge-ci-setup=2 conda-build -c conda-forge

# set up the condarc
setup_conda_rc "${FEEDSTOCK_ROOT}" "${RECIPE_ROOT}" "${CONFIG_FILE}"

run_conda_forge_build_setup

# Install the yum requirements defined canonically in the
# "recipe/yum_requirements.txt" file. After updating that file,
# run "conda smithy rerender" and this line will be updated
# automatically.
/usr/bin/sudo -n yum install -y libX11-devel
exit 9

# make the build number clobber
make_build_number "${FEEDSTOCK_ROOT}" "${RECIPE_ROOT}" "${CONFIG_FILE}"

conda build "${RECIPE_ROOT}" -m "${CI_SUPPORT}/${CONFIG}.yaml" \
    --clobber-file "${CI_SUPPORT}/clobber_${CONFIG}.yaml"

if [[ "${UPLOAD_PACKAGES}" != "False" ]]; then
    upload_package "${FEEDSTOCK_ROOT}" "${RECIPE_ROOT}" "${CONFIG_FILE}"
fi

touch "/home/conda/feedstock_root/build_artifacts/conda-forge-build-done-${CONFIG}"
