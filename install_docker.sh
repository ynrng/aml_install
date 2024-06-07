#!/bin/bash

echo "Starting>>> install_docker.sh"

IMAGETYPE=$1

ROOT_DIR="$(cd $( dirname ${BASH_SOURCE[0]} ) && pwd)"


${ROOT_DIR}/fetch_aml.sh $3 $2
AML_PATH=$(cat $ROOT_DIR/.aml_path)

cd ${AML_PATH} && git checkout $2
cd aml_docker


echo "Running>>> ./docker_build.sh ${IMAGETYPE}"
./docker_build.sh ${IMAGETYPE}
./build_aml.sh aml:${IMAGETYPE} $AML_PATH
