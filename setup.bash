#!/bin/bash
source /opt/ros/humble/setup.bash

# Source DELTA WS
export WS="$(pwd)/../../"
source $WS/install/setup.bash
echo "Sourced WS at $WS"

# Source Optitrack
export OPTITRACK_WS="${OPTITRACK_WS:=$HOME/ros2/optitrack_ws}"
source $OPTITRACK_WS/install/setup.bash
echo "Sourced Optitrack WS at $OPTITRACK_WS"
