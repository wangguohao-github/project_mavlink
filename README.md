Project MAVLink Integration with Aerostack2

This repository provides configuration and integration code for running Aerostack2 with MAVROS and Pixhawk on a Raspberry Pi.
The system enables serial communication between the Raspberry Pi and Pixhawk (via TELEM2) for drone control and data collection.

1. Clone Dependencies

To replicate this project, clone the as2_platform_mavlink package into your workspace source folder:

cd ~/project_mavlink
git clone https://github.com/aerostack2/as2_platform_mavlink.git

2. Change the mavros_config.yaml file

/**:
  ros__parameters:
    fcu_url: "serial:///dev/ttyAMA0:921600"  # Serial device used by Pixhawk TELEM2
    gcs_url: ""                              # Leave empty for on-board operation
    tgt_component: 1                         # Target component ID
    log_output: "screen"                     # Output logs to screen
    fcu_protocol: "v2.0"                     # MAVLink protocol version
    respawn_mavros: "false"                  # Disable auto-respawn

drone0:
  mavros/mavros_node:
    ros__parameters:
      fcu_url: "udp://:14540@127.0.0.1:14557"
      tgt_system: 1

drone1:
  mavros/mavros_node:
    ros__parameters:
      fcu_url: "udp://:14541@127.0.0.1:14558"
      tgt_system: 2

drone2:
  mavros/mavros_node:
    ros__parameters:
      fcu_url: "udp://:14542@127.0.0.1:14559"
      tgt_system: 3

drone3:
  mavros/mavros_node:
    ros__parameters:
      fcu_url: "udp://:14543@127.0.0.1:14560"
      tgt_system: 4

