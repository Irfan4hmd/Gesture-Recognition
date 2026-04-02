# Edge Gesture-to-Speech HRI Interface

This repository contains the source code and deployment scripts for a real-time Gesture-to-Speech Human-Robot Interaction (HRI) interface. It is designed specifically for resource-constrained Linux edge devices like the NVIDIA Jetson Nano and Raspberry Pi.

## Key Features

- **Automated Deployment**: Bash scripts to set up the environment and configure systemd services for headless, autonomous startup.
- **Resource Optimization**: Optimized CNN inference for edge hardware, balancing accuracy with processing efficiency.
- **Robust Configuration**: Git-tracked configuration management to easily rollback camera driver or model parameter changes.
- **Containerization**: Dockerfile included for isolated testing and deployment.

## Setup Instructions

1. **Install Dependencies**:

   ```bash
   ./scripts/install_dependencies.sh
   ```

2. **Configure Autostart**:
   To make the system "production ready" and launch without manual input after a reboot:

   ```bash
   ./scripts/setup_autostart.sh
   ```

3. **Configuration Management & Deployment**:
   All settings are stored in `config/settings.yaml`. We use custom deployment scripts to ensure safe updates and rollbacks:

   ```bash
   # Safely deploy new code (creates a backup first)
   ./scripts/deploy_update.sh

   # Rollback to the previous working configuration if something breaks
   ./scripts/rollback_config.sh
   ```

4. **System Health Monitoring**:
   A cron-based health monitor ensures the camera and service stay active:
   ```bash
   ./scripts/monitor_health.sh
   ```

## Hardware Requirements

- Jetson Nano
- USB Web Camera
- Audio output device (Speaker)
