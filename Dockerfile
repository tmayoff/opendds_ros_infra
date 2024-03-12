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

RUN git clone https://github.com/OpenDDS/OpenDDS.git -b DDS-3.26.1 /opt/OpenDDS

WORKDIR /opt/OpenDDS
RUN cmake -S . -B build -G Ninja 
RUN cmake --build build

ENV ACE_ROOT=/usr/local/share/ace \
    TAO_ROOT=/usr/local/share/tao \
    DDS_ROOT=/usr/local/share/dds \
    MPC_ROOT=/usr/local/share/MPC

WORKDIR /opt/workspace

FROM opendds as ros

RUN apt-get update && apt-get upgrade -y

RUN apt-get install ros-humble-turtlesim
