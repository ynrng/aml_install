#!/bin/bash

IMAGETYPE=$1

ROOT_DIR="$(cd $( dirname ${BASH_SOURCE[0]} ) && pwd)"
AML_BRANCH=$(cat ${ROOT_DIR}/aml.branch)

${ROOT_DIR}/fetch_aml.sh $2
AML_PATH=$(cat $ROOT_DIR/.aml_path)

cd ${AML_PATH} && git checkout ${AML_BRANCH}
cd aml_docker


./docker_build.sh ${IMAGETYPE}
./build_aml.sh dev:${IMAGETYPE}
