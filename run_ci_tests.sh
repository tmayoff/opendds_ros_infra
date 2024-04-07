#!/usr/bin/env -S cargo +nightly -Zscript
```cargo
[dependencies]
async-process = "2.2.0"
async-std = { version = "1.12.0", features = ["attributes"] }
```

use async_process::Command;

#[async_std::main]
async fn main() {
    let mut subscriber = Command::new("ros2")
        .args([
            "run",
            "examples_rclcpp_minimal_subscriber",
            "subscriber_member_function",
        ])
        .kill_on_drop(true)
        .spawn()
        .expect("Failed to spawn subscriber");

    let mut publisher = Command::new("ros2")
        .args([
            "run",
            "examples_rclcpp_minimal_publisher",
            "publisher_member_function",
        ])
        .kill_on_drop(true)
        .spawn()
        .expect("Failed to spawn publisher");

    println!("SUBSCRIBER ID: {:?}", subscriber.id());
    println!("PUBLISHER ID: {:?}", publisher.id());

    std::thread::sleep(std::time::Duration::from_secs(5));
    std::process::Command::new("kill")
        .args([
            "-9",
            &subscriber.id().to_string(),
            &publisher.id().to_string(),
        ])
        .spawn()
        .expect("Failed to kill pub/sub");

    subscriber.kill().expect("Failed to kill publisher");
    publisher.kill().expect("Failed to kill publisher");
    println!("Subscriber STATUS: {:?}", subscriber.status().await);
    println!("PUBLISHER STATUS: {:?}", publisher.status().await);
}
