# PX4 MAVROS Drone

## Building / Installing 

### Raspberry Pi Setup

### OS version


### Main Dependencies 

Installing Docker



#### Udev Rule Setup

You can use udev rules to ensure that when you plugin the Pixhawk that it will be recognised as such. There is a rule in this repo for it, copy it onto the raspberry pi into the following location:

```bash
sudo cp utils/99-pixhawk.rules /etc/udev/rules.d/
sudo udevadm control --reload-rules
```

This will connect up all pixhawks as either ttyPixhawk or ttyFTDI

Ensure that the `config/mavlink-router.conf` is setup to reflect this. 

### Docker Container Build

#### Building Locally


#### Building Cross-Platform for the Raspberry Pi


## Running 