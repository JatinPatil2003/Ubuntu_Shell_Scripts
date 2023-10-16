#!/bin/bash

echo "Installing ROS2-Humble Source"

locale  # check for UTF-8

sudo apt update && sudo apt install locales
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

locale  # verify settings

sudo apt install software-properties-common
sudo add-apt-repository universe

sudo apt update && sudo apt install curl -y
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

sudo apt update && sudo apt install -y \
  python3-flake8-docstrings \
  python3-pip \
  python3-pytest-cov \
  ros-dev-tools

python3 -m pip install -U \
   flake8-blind-except \
   flake8-builtins \
   flake8-class-newline \
   flake8-comprehensions \
   flake8-deprecated \
   flake8-import-order \
   flake8-quotes \
   "pytest>=5.3" \
   pytest-repeat \
   pytest-rerunfailures

mkdir -p ~/ros2_humble/src
cd ~/ros2_humble
vcs import --input https://raw.githubusercontent.com/ros2/ros2/humble/ros2.repos src

sudo apt upgrade

sudo rosdep init
rosdep update
rosdep install --from-paths src --ignore-src -y --skip-keys "fastcdr rti-connext-dds-6.0.1 urdfdom_headers"

cd ~/ros2_humble/
colcon build --symlink-install

cd 

mkdir colcon_ws
cd colcon_ws
mkdir src

colcon build --symlink-install

echo "source ~/colcon_ws/install/setup.bash" >> ~/.bashrc
echo "source ~/ros2_humble/install/setup.bash" >> ~/.bashrc
source ~/.bashrc

echo "------------------------------"
echo "Installed ROS 2 HUMBLE        "
echo "------------------------------"