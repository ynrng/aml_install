# AML Installation Step-by-Step
Public install scripts for the Advanced Manipulation Learning (AML) framework.

## Setting Up 

0. If your network is behind a proxy, make sure the instructions [here](https://gist.github.com/justagist/7b544626136537774961c5c5f563d18d) are followed for proper installation of AML Docker.

1. Install Docker CE (v >= 19.0), see [installation instructions](https://docs.docker.com/engine/installation/).

  * Also perform the [post installation instructions](https://docs.docker.com/engine/installation/linux/linux-postinstall/), so that docker can be run without requiring root privileges by a non-root user. (this is optional, otherwise, scripts must be run as root)

2. (optional) If you want to use GPU and CUDA in docker, follow [these instructions](#amldocker-cuda-preinstallation-setup) before setting up the AML Docker. If not, go to [Building AML Docker](#building-aml-docker).

### AMLDocker CUDA Preinstallation Setup

You need to have nvidia graphics card. Skip this section if you don't.

1) Install nvidia driver (>= nvidia-418)

  * Recommended method:

  ```
  sudo add-apt-repository ppa:graphics-drivers/ppa
  sudo apt update
  
  ```

  Then, on Ubuntu from the menu / Dash, click on the "Additional Drivers" and on the tab with the same name, select the driver you want to use, and "Apply changes". Wait until the driver is downloaded and installed, and reboot.



2) Install [nvidia container toolkit](https://github.com/NVIDIA/nvidia-docker):

```
# Add the package repositories
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
sudo systemctl restart docker
 ```

3) Install [nvidia-docker2](https://github.com/nvidia/nvidia-docker/wiki/Installation-(version-2.0)):

 ```
sudo apt-get install nvidia-docker2
sudo pkill -SIGHUP dockerd

 ```

### Building AML Docker

  * If you want to select a specific branch, clone this repository, modify `aml.branch` to contain your desired AML branch name, then run `./install.sh`. Otherwise, you can run the install script without cloning the repository manually (see example below)
  * you will require around 5GB of free space for the container

The example below sets up a docker image with ubuntu 14.04, GPU acceleration, ROS melodic and all other required dependencies for AML. It creates a default catkin workspace located at `$HOME/Projects/aml_ws`. The host machine does not have to have ROS installed. It only needs to have docker and (optionally) nvidia-docker.

`bash -c "$(curl -fsSL https://raw.githubusercontent.com/justagist/aml_install/master/install.sh)" <optional keyword arguments> [build-name]`

Keyword arguments:

```
  $ --workspace <absolute path> : path to create AML workspace (Default: $HOME/Projects/aml_ws)
  $ --branch <branch name> : AML git branch to use (default 'melodic-dev')
 ```

You can choose other docker builds. See list below:

  * melodic-cuda
  * melodic-cuda-python3 (under development; needs AML branch `python3_dev`; not recommended for now)
  * melodic
  * melodic-python3 (under development; needs AML branch `python3_dev`; not recommended for now)
  * kinetic-cuda
  * kinetic
  
After running the script line above you should be able to see a new image set up on your docker and tagged as `dev:melodic-cuda`. You should be able to list it by doing `docker images`. 


### Using the container

Now in the AML docker folder located at `$HOME/Projects/aml_ws/src/aml/aml_docker` you will find a set of scripts that will help you run your docker container, among other examples. For instance, if you want to open a bash shell to the docker container just built, then execute or source the script:

`$HOME/Projects/aml_ws/src/aml/aml_docker/bash.sh dev:melodic-cuda` 
(NOTE: image tag is passed as argument to the script).

This should open a bash shell and spin the container. Check if RVIZ is running in the container by running in the bash shell opened:

```
roscore > /dev/null &
rosrun rviz rviz
```

This should open an X window on your host machine with RVIZ. If you installed the CUDA variant of AML Docker, this means your docker is being hardware accelerated and able to use the host GPU for 3D rendering.

The container will close once the session exits.

To open another terminal session into the container, run `./exec_container $(./get_containerId.sh)`. The container will not close when this session exits.

Alternatively, setup aliases for easier loading of image and opening new terminal session by adding the following lines to your '.bashrc' file:

```
function amldocker () { $AML_DIR/aml_docker/bash.sh dev:<NAME_OF_DOCKER_BUILD_CHOSEN>; cd $AML_DIR/../../; }
function newdockterm (){ $AML_DIR/aml_docker/exec_container.sh $($AML_DIR/aml_docker/get_containerId.sh); cd $AML_DIR/../../; }
```

Any files written to `$HOME/Projects/` or other directories mounted inside the container will be observable from the host machine. The intention is that development can be done on the host machine, but run inside the container.


### Setting up host computer without docker

The example below assumes a fresh install of ubuntu 14.04. It installs ROS melodic and all other required dependencies for AML (obs.: without GPU acceleration).

`bash -c "$(curl https://raw.githubusercontent.com/justagist/aml_install/master/install_melodic_host.sh)"`
