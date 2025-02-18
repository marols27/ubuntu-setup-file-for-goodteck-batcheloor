#!/bin/bash
# Ros2 setup:
set -x

locale  # check for UTF-8
apt update && apt install locales
locale-gen en_US en_US.UTF-8
update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8
locale  # verify settings
apt install software-properties-common -y
add-apt-repository universe -y
apt update && apt install curl gnupg2 lsb-release -y
curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null
apt update && apt install ros-dev-tools -y
apt update
apt upgrade -y
apt install ros-jazzy-desktop -y
apt install ros-jazzy-ros-base -y

# Replace ".bash" with your shell if you're not using bash
# Possible values are: setup.bash, setup.sh, setup.zsh
source /opt/ros/jazzy/setup.bash



# Gazebo setup:
apt install ros-${ROS_DISTRO}-ros-gz -y

echo 'export LIBGL_ALWAYS_SOFTWARE=1' >> ~/.bashrc
echo 'export QT_QPA_PLATFORM=xcb' >> ~/.bashrc
source ~/.bashrc



# Setup the ros2 workspace
mkdir -p ~/ros2_ws/src
cd ~/ros2_ws/src
git clone https://github.com/ros/ros_tutorials.git -b jazzy
# cd if you're still in the ``src`` directory with the ``ros_tutorials`` clone
cd ..
rosdep init
rosdep update
rosdep install -i --from-path src --rosdistro jazzy -y
source /opt/ros/jazzy/setup.bash



# Universal Robots package download:
cd ~/ros2_ws/src
git clone -b ros2 https://github.com/UniversalRobots/Universal_Robots_ROS2_GZ_Simulation.git ~/ros2_ws/src/ur_simulation_gz
rosdep update
rosdep install --from-paths src --ignore-src -r -y
cd ..
colcon build --symlink-install
source ~/ros2_ws/install/setup.bash

