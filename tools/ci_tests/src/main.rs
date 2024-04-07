use std::io;

use anyhow::Result;
use async_process::{Command, Stdio};
use futures_lite::{future, prelude::*};

fn main() -> Result<()> {
    async_io::block_on(async {
        let mut subscriber = Command::new("./install/examples_rclcpp_minimal_subscriber/lib/examples_rclcpp_minimal_subscriber/subscriber_member_function")
                .kill_on_drop(true).stdout(Stdio::piped()).stderr(Stdio::piped())
        .spawn()
        .expect("Failed to spawn publisher");

        let  publisher = Command::new("./install/examples_rclcpp_minimal_publisher/lib/examples_rclcpp_minimal_publisher/publisher_member_function")
        .kill_on_drop(true)
        .spawn()
        .expect("Failed to spawn publisher");

        let sub_id = subscriber.id();
        let pub_id = publisher.id();
        std::thread::spawn(move || {
            std::thread::sleep(std::time::Duration::from_secs(5));

            std::process::Command::new("kill")
                .args(["-9", &pub_id.to_string(), &sub_id.to_string()])
                .spawn()
                .expect("Failed to kill processses");
        });

        // Run a future to drain the stdout of the child.
        // We can't use output() here because it would be cancelled along with the child when the timeout
        // expires.
        let mut stdout = String::new();
        let drain_stdout = {
            let buffer = &mut stdout;
            let mut stdout = subscriber.stdout.take().unwrap();

            async move {
                stdout.read_to_string(buffer).await?;

                // Wait for the child to exit or the timeout.
                future::pending().await
            }
        };

        // Run a future to drain the stderr of the child.
        let mut stderr = String::new();
        let drain_stderr = {
            let buffer = &mut stderr;
            let mut stderr = subscriber.stderr.take().unwrap();

            async move {
                stderr.read_to_string(buffer).await?;

                // Wait for the child to exit or the timeout.
                future::pending().await
            }
        };

        // Run a future that waits for the child to exit.
        let wait = async move {
            subscriber.status().await?;

            // Child exited.
            io::Result::Ok(false)
        };

        drain_stdout.or(drain_stderr).or(wait).await?;

        println!("Stdout:\n{}", stdout);
        println!("Stderr:\n{}", stderr);

        if stderr.contains("I heard: 'Hello, world!") {
           return Ok(()); 
        }
    
        Err(anyhow::anyhow!("Subscriber didn't receive any samples"))
    })
}
