#!/bin/bash

# usage:
# ./install.sh -w /code/aml_ws/ -b noetic-dev
# bash -c "$(curl https://raw.githubusercontent.com/ynrng/aml_install/noetic-dev/install.sh)" -w /code/aml_ws/ -b noetic bash

INSTALL_TYPE="noetic"
INSTALL_FROM_HOST=false
WORKSPACE_PATH="$HOME/code/aml_ws/"

# checking if this script is being run from the curl-based install script or locally from host machine
# parameter base is different if run locally
key=$0

if [ "$key" == "./install.sh" ]
then
	INSTALL_FROM_HOST=true
else
	# compatibility with curl-based install
	args=$@
	vals=( "$0" ${args[@]} )
	set -- "${vals[@]}"
fi


# echo "$0"
# echo "$1"
# echo "$2"

while [[ $# -gt 0 ]]; do

	key="$1"
	value="$2"

	# echo $key
	# echo $value
	# echo " "
    case $key in
        -w|--workspace)
        WORKSPACE_PATH="$value"
        shift # past argument
        shift # past value
        ;;
        -b|--aml_branch)
        INSTALL_TYPE="$value"
        shift # past argument
        shift # past value
        ;;
        # *)    # unknown option
        # INSTALL_TYPE+=("$key") # save it in an array for later
        # shift # past argument
        # ;;
		-*|--*=) # unsupported flags
		echo "Error: Unsupported flag $1" >&2
		exit 1
		;;
		*) # preserve positional arguments
		PARAMS="$PARAMS $key"
		shift
		;;
    esac
done

BRANCH="${INSTALL_TYPE}-dev"

echo "INSTALL_TYPE: $INSTALL_TYPE"
echo "WORKSPACE_PATH: $WORKSPACE_PATH"
echo "GIT BRANCH: $BRANCH"


if [ "$INSTALL_FROM_HOST" == "true" ] && [ -z $WORKSPACE_PATH ]
then
	echo "WORKSPACE_PATH is empty: will prompt to use default, i.e. $WORKSPACE_PATH"
fi


if [ "$INSTALL_FROM_HOST" == "true" ]
then
	echo "Local install..."
	ROOT_DIR="$(cd $( dirname ${BASH_SOURCE[0]} ) && pwd)"
	echo "Running... $ROOT_DIR/install_on_host.sh $BRANCH $WORKSPACE_PATH"
	$ROOT_DIR/install_docker.sh $INSTALL_TYPE $BRANCH $WORKSPACE_PATH
else
	if [ -z "$INSTALL_TYPE" ] || [ "$INSTALL_TYPE" == "bash" ]
	then
	    echo "usage: ./install.sh <install-options> <image-type>"
	    echo "example: ./install.sh -w $HOME/code/ -b melodic-dev"
	    echo "install options: --branch: AML git branch"
	    echo "                 --workspace: absolute path to create workspace (Default: $HOME/code/aml_ws)"
		exit 1
	fi
	echo "Curl-based install..."
	mkdir -p $WORKSPACE_PATH && cd $WORKSPACE_PATH
	rm -rf aml_install
	git clone --depth 1 -b $BRANCH https://github.com/ynrng/aml_install.git aml_install
	cd aml_install
	echo "Running... ./install_docker.sh" $INSTALL_TYPE $BRANCH $WORKSPACE_PATH
	./install_docker.sh $INSTALL_TYPE $BRANCH $WORKSPACE_PATH
fi
