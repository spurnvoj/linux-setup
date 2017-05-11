#!/bin/bash
ping -c 1 192.168.0.10$1 >> /dev/null
if [ $? -eq 0 ]; then
echo -n '10'$1
export ROS_MASTER_URI=http://192.168.0.10$1:11311
export ROS_IP=export ROS_IP=`hostname -I`
source /opt/ros/indigo/setup.bash
source ~/ros_workspace/devel/setup.bash
var=`timeout 5 rostopic echo -n 1 /uav$1/rtk_gps/diagnostics | awk '/Fix type/ { getline; print substr($0,15,12) }'`
echo -n ' '
echo $var
echo
var2=no_fix
if [ "$var" == "$var2" ]; then
  echo '#006000'
else
  echo '#FF0000'
fi
else
  echo ''
fi
