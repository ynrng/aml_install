#!/bin/bash

# INSTALL_TYPE=
INSTALL_FROM_HOST=false

# checking if this script is being run from the curl-based install script or locally from host machine
# parameter base is different if run locally
key=$0

if [ "$key" == "./install.sh" ]
then
	INSTALL_FROM_HOST=true
else
	# compatibility with curl-based install
	args=$@
	vals=( ${args[@]} )
	set -- "${vals[@]}"
fi


BRANCH="melodic-dev"

# echo "$0"
echo "$1"
echo "$2"

# while [[ $# -gt 0 ]]; do

# 	key="$1"
# 	value="$2"

# 	echo $key
# 	echo $value
# 	echo " "
#     case $key in
#         -w|--workspace)
#         WORKSPACE_PATH="$value"
#         shift # past argument
#         shift # past value
#         ;;
#         -b|--aml_branch)
#         BRANCH="$value"
#         shift # past argument
#         shift # past value
#         ;;   
#         *)    # unknown option
#         INSTALL_TYPE+=("$key") # save it in an array for later
#         shift # past argument
#         ;;
#     esac
# done

# echo "INSTALL_TYPE: $INSTALL_TYPE"
# echo "WORKSPACE_PATH: $WORKSPACE_PATH"
# echo "GIT BRANCH: $BRANCH"


# if [ "$INSTALL_FROM_HOST" == "true" ] && [ -z $WORKSPACE_PATH ]
# then
# 	echo "WORKSPACE_PATH is empty: will prompt to use default, i.e. aml_ws"
# fi


# if [ "$INSTALL_FROM_HOST" == "true" ]
# then
# 	echo "Local install..."
# 	ROOT_DIR="$(cd $( dirname ${BASH_SOURCE[0]} ) && pwd)"
# 	${ROOT_DIR}/install_on_host.sh $BRANCH $WORKSPACE_PATH
# else
# 	if [ -z "$INSTALL_TYPE" ] || [ "$INSTALL_TYPE" == "bash" ]
# 	then 
# 	    echo "usage: ./install.sh <install-options> <image-type>"
# 	    echo "example: ./install.sh --workspace $HOME/Projects/ melodic-dev"
# 	    echo "install options: --branch: AML git branch"
# 	    echo "                 --workspace: absolute path to create workspace (Default: $HOME/Projects/aml_ws)"
# 		exit 1
# 	fi
# 	echo "Curl-based install..."
# 	rm -rf /tmp/aml_install
# 	git clone --depth 1 -b master https://github.com/justagist/aml_install.git /tmp/aml_install
# 	cd /tmp/aml_install
# 	./install_docker.sh $INSTALL_TYPE $BRANCH $WORKSPACE_PATH
# fi

