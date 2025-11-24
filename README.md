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

Ensure that the `root_config/mavlink-router.conf` is setup to reflect this. 

### Docker Container Build

#### Building Locally


#### Building Cross-Platform for the Raspberry Pi


## Running 
docker-compose.yaml file is in root_config folder. Put it into the root directory of raspberry pi and run 
```bash
sudo docker compose up -d
```

## Launch the drone and ground station
### Turn on the drone
Put the drone on charge, turn on the voltage adapter which will power raspberry pi. The docker container will automatically start.

### Access the server
The server hostname is: flight-arena-server
The password is: flight-arena

```bash
ssh flight-arena-server@flight-arena-server.local
```

After logging in, navigate to the project directory and launch:
```bash
cd ~/project_mavlink/
./launch_ground_station.bash -n qav1
```
### Launch the qgroundcontrol on your laptop
Create a new udpendpoint to the mavlink router on the server, the config file is located at:
```bash
/etc/mavlink-router/main.conf
```

Restart the mavlink-router by running:
```bash
sudo systemctl restart mavlink-router
```

Then on your laptop, 
```bash
./QGroundControl-x86_64.AppImage
```
### (Optional) Access the raspberry pi
If you wish to access the drone companion computer (raspberry pi):
```bash
ssh qav-1@qav1.local
```
The password is:
```bash
robodome
```

##Trouble shooting
###Unable to connect to drone controller
stay close to the drone atena, unplug drone battery and plug again.
###The qgroundcontrol can't receive message.
Create a new udpendpoint to the mavlink router on the server, the config file is located at:
```bash
/etc/mavlink-router/main.conf
```


