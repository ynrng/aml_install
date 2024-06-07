#!/bin/bash

echo "Starting>>> install_on_host.sh"

ROOT_DIR="$(cd $( dirname ${BASH_SOURCE[0]} ) && pwd)"

echo "Running... $ROOT_DIR/fetch_aml.sh $2 $1"
# ${ROOT_DIR}/fetch_aml.sh $2 $1 TODO: uncomment this line

AML_PATH=$(cat $ROOT_DIR/.aml_path)

cd ${AML_PATH} && git checkout $1

cd aml_scripts

./install_${ROS_DISTRO}_deps.sh

source setup_rospkg_deps.sh
