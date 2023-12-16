# ROS2 OpenDDS tooling

**Dockerfile**: copied from the OpenDDS repo, and switched to use `ros:humble` as the base.

**rmw_build**: A fork of the original rmw_build with some minor tweaks to the scripts, and changes to point some repos to my forks

**github actions**: 
- Build and publush opendds_ros2 image to github packages
- Build and test rmw_opendds with the rmw_build repo scripts

## Forks
- https://github.com/tmayoff/rmw_opendds/tree/humble
- https://github.com/tmayoff/rosidl_typesupport_opendds/tree/humble
