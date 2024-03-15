# AML Installation Step-by-Step

Public install scripts for the IRLab Advanced Manipulation Learning (AML) framework.

## Setting Up 

0. If your network is behind a proxy, make sure the instructions [here](https://gist.github.com/justagist/7b544626136537774961c5c5f563d18d) are followed for proper installation of AML Docker.

1. Install Docker CE (v >= 19.0), see [installation instructions](https://docs.docker.com/engine/installation/).

  * Also perform the [post installation instructions](https://docs.docker.com/engine/installation/linux/linux-postinstall/), so that docker can be run without requiring root privileges by a non-root user. (this is optional but recommended, otherwise scripts will have to be run as root)

2. (optional) If you have an NVidia GPU and want to use GPU acceleration/CUDA in docker (required mainly for tensorflow and for boosting some visualisers), follow [these instructions](#amldocker-cuda-preinstallation-setup) before setting up the AML Docker. If not, go to [Building AML Docker](#building-aml-docker). 

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

Once completed, go to [Building AML Docker](#building-aml-docker).

### Building AML Docker

  * If you want to select a specific branch, clone this repository, modify `aml.branch` to contain your desired AML branch name, then run `./install.sh`. Otherwise, you can run the install script without cloning the repository manually (see example below)
  * you will require around 5GB of free space for the container

**Recommended method:**

The default (recommended) options will be applied and the library should be fully installed automatically by running one of the following commands. It sets up a docker image with ubuntu 18.04, (optionally GPU acceleration,) ROS noetic and all other required dependencies for AML. It creates a default catkin workspace located at `$HOME/code/aml_ws`. The host machine **does not** have to have ROS installed. It only needs to have docker and (optionally) nvidia-docker as described above.

NOTE: `sudo` privileges and `github` authentications may be required during installation.

```
# Without CUDA:
bash -c "$(curl -fsSL https://raw.githubusercontent.com/IRUOB/aml_install/noetic-dev/install.sh)" noetic

# With CUDA (only if you have followed steps mentioned in 'AMLDocker CUDA Preinstallation Setup'):
bash -c "$(curl -fsSL https://raw.githubusercontent.com/IRUOB/aml_install/master/install.sh)" noetic-cuda
```

After running the script line above you should be able to see a new image set up on your docker and tagged as `dev:noetic-cuda` or `dev:noetic`. You should be able to list it by running `docker images`. Go to [Using the Container](#using-the-container) section for instructions to use the docker container.

**Advanced Installation Options (for developers)**

`bash -c "$(curl -fsSL https://raw.githubusercontent.com/IRUOB/aml_install/master/install.sh)" <optional keyword arguments> [build-name]`

Keyword arguments:

```
  $ --workspace <absolute path> : path to create AML workspace (Default: $HOME/code/aml_ws)
  $ --aml_branch <branch name> : AML git branch to use (default 'noetic-dev')
 ```

You can choose other docker builds. See list below:

  * noetic
  * noetic-cuda
  * melodic-cuda
  <!-- * melodic-cuda-python3 (under development; needs AML branch `python3_dev`; not supported for now) -->
  * melodic
  <!-- * melodic-python3 (under development; needs AML branch `python3_dev`; not supported for now) -->
  * kinetic-cuda
  * kinetic
  * indigo (DEPRECATED)



### Using the container

Now in the AML docker folder located at `$HOME/code/aml_ws/src/aml/aml_docker` you will find a set of scripts that will help you run your docker container, among other examples. For instance, if you want to open a bash shell to the docker container just built, then execute or source the script:

`$HOME/code/aml_ws/src/aml/aml_docker/bash.sh dev:<NAME_OF_DOCKER_BUILD_CHOSEN>` 
(NOTE: image tag is passed as argument to the script).

This should open a bash shell and spin the container. Check if RVIZ is running in the container by running in the bash shell opened:

```bash
roscore > /dev/null &
rosrun rviz rviz
```

This should open an X window on your host machine with RVIZ. If you installed the CUDA variant of AML Docker, this means your docker is being hardware accelerated and able to use the host GPU for 3D rendering.

The container will close once the session exits (`exit` command or `CTRL+D`).

To open another terminal session into an existing container, open a new terminal and run `./exec_container $(./get_containerId.sh)`. The container will not close when this session exits. (Note: All terminal sessions will be closed if the main (parent) container is stopped.) Multiple terminal sessions can be opened in this fashion.

Alternatively, setup aliases for easier loading of image and opening new terminal session by adding the following lines to your '.bashrc' file:

```
# Alias to start a new AML Docker
function amldocker () { $AML_DIR/aml_docker/bash.sh dev:<NAME_OF_DOCKER_BUILD_CHOSEN>; cd $AML_DIR/../../; }

# Alias to connect to an existing AML Docker image instance (multiple terminals can be opened like this, but only one image instance should be running).
function newdockterm (){ $AML_DIR/aml_docker/exec_container.sh $($AML_DIR/aml_docker/get_containerId.sh); cd $AML_DIR/../../; }
```

To exit any container, use `exit` command, or `CTRL+D` keys.

Any files written to `$HOME/code/` or other directories mounted inside the container will be observable from the host machine. The intention is that development can be done on the host machine, but run inside the container.

### In-Docker Instructions

Start AML Docker by running `amldocker`, unless it is already running.

If your computer is in the `robot network`, update the files `intera.sh`,`franka.sh` and `baxter.sh` with your IP. By running `source <file_name>` using either of these files, you will be connected to the robot (for the Franka robot, make sure you have followed the instructions from the [franka_ros_interface](https://github.com/IRUOB/franka_ros_interface) repository for connecting to the robot).

AML library simulators can be used regardless of whether you are in the robot network. All the above files can be run using the `sim` argument to enter the simulation environment for the robots (eg: `source intera.sh sim`). Sourcing any of the files in simulation will allow you to run all the robots in simulation.

Test the robot simulators using the commands:
```
roslaunch sawyer_gazebo sawyer_world.launch  # for sawyer robot
roslaunch baxter_gazebo baxter_world.launch  # for baxter robot
roslaunch panda_gazebo panda_world.launch    # for panda robot

```
These simulators should each mimic the behaviour of the real robot. This can be tested by running `rostopic list` in another terminal (open new terminal, run `newdockterm`). All (or most of the) ROS topics published and subscribed by the real robot should be listed for the simulated robot as well. These can be accessed using the ROS functionalities, or the interfaces and scripts in AML, just like the real robot.


### Setting up host computer without docker **(Deprecated; Not recommended)**

The example below assumes a fresh install of ubuntu 14.04. It installs ROS noetic and all other required dependencies for AML (obs.: without GPU acceleration).

`bash -c "$(curl https://raw.githubusercontent.com/IRUOB/aml_install/master/install_on_host.sh)"`
