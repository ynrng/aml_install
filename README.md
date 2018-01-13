# AML Installation Step-by-Step
Public install scripts for the Advanced Manipulation Learning (AML) framework. 

## Select AML branch

Modify `aml.branch` to contain your desired AML branch name.

## Host machine requirements: setting up docker and (optional) nvidia-docker

1. Install Docker CE, see [installation instructions](https://docs.docker.com/engine/installation/). 

  * Also perform the [post installation instructions](https://docs.docker.com/engine/installation/linux/linux-postinstall/), so that docker can be run without requiring root privileges by a non-root user. (this is optional, otherwise, scripts must be run as root)  
2. (optional) If you have an NVIDIA graphic card, install the latest drivers.
  * Recommended method: 

	```
	sudo add-apt-repository ppa:graphics-drivers/ppa
	sudo apt update
	```

	Then, on Ubuntu from the menu / Dash, click on the "Additional Drivers" and on the tab with the same name, select the driver you want to use, and "Apply changes". Wait until the driver is downloaded and installed, and reboot.


3. (optional) If you have an NVIDIA graphic card and Ubuntu 16.04, install nvidia-docker 1.0. See [installation instructions](https://github.com/NVIDIA/nvidia-docker/wiki/Installation-(version-1.0)). 

  * Also install nvidia-modprobe by running `sudo apt-get install nvidia-modprobe`, possibly a reboot is required.

## Setting up AML with docker

The example below sets up a docker image with ubuntu 14.04, GPU acceleration, ROS indigo and all other required dependencies for AML. It creates a default catkin workspace located at `$HOME/Projects/aml_ws`. The host machine does not have to have ROS installed. It only needs to have docker and (optionally) nvidia-docker.

`bash -c "$(curl https://raw.githubusercontent.com/eaa3/aml_install/master/install.sh)" indigo_gpu_docker`

You can choose other docker builds. See list below:

  * indigo_gpu_docker
  * indigo_docker
  * kinetic_gpu_docker
  * kinetic_docker
  
After running the script line above you should be able to see a new image set up on your docker and tagged as `dev:indigo_gpu_docker`. You should be able to list it by doing `docker images`. 

Now in the AML docker folder located at `$HOME/Projects/aml_ws/src/aml/aml_docker` you will find a set of scripts that will help you run your docker container, among other examples. For instance, if you want to open a bash shell to the docker container just built, then execute or source the script `$HOME/Projects/aml_ws/src/aml/aml_docker/bash.sh dev:indigo_gpu_docker` (note image tag is passed as argument to the script).

### Alternative options upon building the AML docker

If you want to create a different one for the aml catkin workspace created for docker, you can run the above command with an additional parameter below:

`bash -c "$(curl https://raw.githubusercontent.com/eaa3/aml_install/master/install.sh)" indigo_gpu_docker my/path/to-my-catkin-ws`

  * Remember, you do not need to have ROS installed in the host machine. The path for catkin workspace is created in the host so as to make it available for the docker container later, see aml_docker scripts at `$HOME/Projects/aml_ws/src/aml/aml_docker`.

## Setting up host computer without docker

The example below assumes a fresh install of ubuntu 14.04. It installs ROS indigo and all other required dependencies for AML (obs.: without GPU acceleration).

`bash -c "$(curl https://raw.githubusercontent.com/eaa3/aml_install/master/install_indigo_host.sh)"`

