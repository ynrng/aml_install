#!/bin/bash

echo "Starting>>> fetch_aml.sh"

ROOT_DIR="$(cd $( dirname ${BASH_SOURCE[0]} ) && pwd)"
CATKIN_WS_PATH=$1
AML_BRANCH=$2
SHALLOW_CLONE='n'

if [ -z "$CATKIN_WS_PATH" ]
then

    echo "usage: ./fetch_aml.sh [<optional-path-to-catkin-workspace>]"
    CATKIN_WS_PATH=${HOME}/code/aml_ws/
	echo "This script will create a default catkin workpace at ${CATKIN_WS_PATH}, proceed? (y/n)"

	read answer
	if echo "$answer" | grep -iq "^y" ;then
		echo "Fetching AML..."
	else
	    echo "Exiting script. Operation cancelled."
	    exit 1
	fi

fi


# Backing up existing aml directory, if it exists
rm -rf aml.bkp > /dev/null 2>&1
mv -f -b ${CATKIN_WS_PATH}/src/aml ${ROOT_DIR}/aml.bkp > /dev/null 2>&1
mkdir -p ${CATKIN_WS_PATH}/src

CATKIN_WS_ABS_PATH="$( cd "$( dirname "${CATKIN_WS_PATH}/." )" && pwd )"
AML_ABS_PATH="${CATKIN_WS_ABS_PATH}/src/aml"
echo "Change directory->${AML_ABS_PATH}"

CLONE_DEPTH=""
if echo "$SHALLOW_CLONE" | grep -iq "^y" ;then
	CLONE_DEPTH="--depth 1"
fi

git clone ${CLONE_DEPTH} -b ${AML_BRANCH} git@github.com:ynrng/AML.git ${AML_ABS_PATH}

echo "git clone ${CLONE_DEPTH} -b ${AML_BRANCH} git@github.com:ynrng/AML.git ${AML_ABS_PATH}"
echo ${AML_ABS_PATH} > .aml_path