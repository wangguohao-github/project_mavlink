#########################################################################################
# Aerostack2 (apt core) + MAVROS + AS2 Platform MAVLink + Project_Mavlink
#########################################################################################

FROM ros:humble-ros-core

WORKDIR /root

# --------------------------------------------------------------------
# 1. Basic dependencies
# --------------------------------------------------------------------
RUN apt-get update -y && apt-get install -y \
    apt-utils \
    software-properties-common \
    git \
    wget \
    tmux \
    tmuxinator \
    python3-rosdep \
    python3-pip \
    python3-colcon-common-extensions \
    python3-colcon-mixin \
    ros-dev-tools \
    python3-flake8 \
    cppcheck lcov \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install pylint flake8==4.0.1 pycodestyle==2.8 cmakelint cpplint colcon-lcov-result PySimpleGUI-4-foss

# --------------------------------------------------------------------
# 2. ROS dependencies + Aerostack2 core via apt
# --------------------------------------------------------------------
RUN apt-get update -y && apt-get install -y \
    ros-humble-mavros \
    ros-humble-mavros-extras \
    ros-humble-as2-core \
    ros-humble-as2-msgs \
    ros-humble-as2-state-estimator \
    ros-humble-as2-motion-controller \
    ros-humble-as2-behaviors-motion \
    ros-humble-as2-behaviors-trajectory-generation \
    ros-humble-as2-alphanumeric-viewer \
    ros-humble-tf2 \
    ros-humble-tf2-ros \
    ros-humble-tf2-geometry-msgs \
    ros-humble-robot-state-publisher \
    ros-humble-image-transport \
    ros-humble-geographic-msgs \
    ros-humble-mocap4r2-msgs \
    python3-pymap3d \
    python3-jinja2 \
    python3-pydantic \
    libeigen3-dev \
    libyaml-cpp-dev \
    libgeographic-dev \
    pybind11-dev \
    libncurses-dev \
    && rm -rf /var/lib/apt/lists/*

# --------------------------------------------------------------------
# 3. Install GeographicLib datasets manually (safe & portable)
# --------------------------------------------------------------------
RUN wget https://raw.githubusercontent.com/mavlink/mavros/ros2/mavros/scripts/install_geographiclib_datasets.sh && \
    chmod +x install_geographiclib_datasets.sh && \
    ./install_geographiclib_datasets.sh && \
    rm install_geographiclib_datasets.sh

# --------------------------------------------------------------------
# 4. Clone and build as2_platform_mavlink + your project
# --------------------------------------------------------------------
# --------------------------------------------------------------------
# 4. Copy local as2_platform_mavlink and project_mavlink
# --------------------------------------------------------------------
# --------------------------------------------------------------------
# 4. Copy local as2_platform_mavlink and your project
# --------------------------------------------------------------------
RUN mkdir -p /root/aerostack2_ws/src
WORKDIR /root/aerostack2_ws/src

# 你的项目已经包含 as2_platform_mavlink，不需要再单独 COPY
COPY . ./project_mavlink


# --------------------------------------------------------------------
# 5. Build workspace (only minimal packages)
# --------------------------------------------------------------------
WORKDIR /root/aerostack2_ws
RUN . /opt/ros/$ROS_DISTRO/setup.sh && \
    colcon build --symlink-install --cmake-args -DCMAKE_BUILD_TYPE=Release \
        --packages-select as2_platform_mavlink

# --------------------------------------------------------------------
# 6. Setup environment
# --------------------------------------------------------------------
RUN echo "source /opt/ros/$ROS_DISTRO/setup.bash" >> ~/.bashrc && \
    echo "source /root/aerostack2_ws/install/setup.bash" >> ~/.bashrc && \
    echo 'export AEROSTACK2_PATH=/opt/ros/humble/share/aerostack2' >> ~/.bashrc

# --------------------------------------------------------------------
# 7. Default entrypoint (interactive mode)
# --------------------------------------------------------------------
WORKDIR /root/aerostack2_ws/src/project_mavlink
CMD ["/bin/bash", "-ic", "./launch_as2.bash -n qav1"]

