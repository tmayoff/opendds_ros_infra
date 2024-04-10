FROM ghcr.io/tmayoff/opendds_ros_infra:latest

ARG USERNAME=devcontainer
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && adduser --uid $USER_UID --gid $USER_GID --shell /bin/bash $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME


RUN mkdir /workspace && chown -R devcontainer:devcontainer /workspace
