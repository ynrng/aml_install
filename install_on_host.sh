#!/bin/bash


ROOT_DIR="$(cd $( dirname ${BASH_SOURCE[0]} ) && pwd)"
AML_BRANCH=$(cat ${ROOT_DIR}/aml.branch)

${ROOT_DIR}/fetch_aml.sh $2
AML_PATH=$(cat $ROOT_DIR/.aml_path)

cd ${AML_PATH} && git checkout $1

cd aml_scripts

./install_${ROS_DISTRO}_deps.sh

source setup_rospkg_deps.sh
