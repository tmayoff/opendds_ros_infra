.PHONY: build build_rmw build_examples

build: 
	colcon build --symlink-install --cmake-args -DCMAKE_EXPORT_COMPILE_COMMANDS=On

build_rmw:
	colcon build --symlink-install --packages-up-to rmw_opendds_cpp

build_examples: build_rmw
	colcon build --symlink-install --packages-up-to examples_rclcpp_minimal_publisher examples_rclcpp_minimal_subscriber examples_rclcpp_minimal_service examples_rclcpp_minimal_client

rosdep:
	rosdep install -y --from-paths src --ignore-src --skip-keys "opendds libopendds opendds_cmake_module rosidl_typesupport_opendds_c rosidl_typesupport_opendds_cpp"

test: build_examples
	./rmw_build/run_ci_test.sh
