ARG BASIS=ros:humble
FROM $BASIS as opendds

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    curl \
    g++ \
    make \
    libxerces-c-dev \
    libssl-dev \
    perl-base \
    perl-modules \
    git \
    ninja-build

RUN curl https://apt.kitware.com/kitware-archive.sh -o kitware-archive.sh && chmod +x kitware-archive.sh && ./kitware-archive.sh
RUN apt-get -y update && apt-get -y install cmake

RUN git clone https://github.com/OpenDDS/OpenDDS.git -b DDS-3.27 /opt/OpenDDS

# WORKDIR /opt/OpenDDS
# RUN cmake -S . -B build -G Ninja 
# RUN cmake --build build
# RUN cd build && ninja install

ARG ACE_CONFIG_OPTION="--doc-group"
RUN cd /opt/OpenDDS && \
    ./configure --prefix=/usr/local --security ${ACE_CONFIG_OPTION} && \
    ./tools/scripts/show_build_config.pl && \
    make && \
    make install && \
    ldconfig && \
    . /opt/OpenDDS/setenv.sh && \
    cp -a ${MPC_ROOT} /usr/local/share/MPC

ENV ACE_ROOT=/usr/local/share/ace \
    TAO_ROOT=/usr/local/share/tao \
    DDS_ROOT=/usr/local/share/dds \
    MPC_ROOT=/usr/local/share/MPC

WORKDIR /opt/workspace

FROM opendds as ros

ARG USERNAME=devcontainer
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && adduser --uid $USER_UID --gid $USER_GID --shell /bin/bash $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

RUN apt-get update -y && apt-get upgrade -y

RUN apt-get install -y ros-humble-turtlesim
