<div
  align="center">
  <img
    src="image/logo.svg"
    alt="Simple ZRAM Logo"
    style="display: block; margin: 0 auto;"
  />
</div>

## Introduction

**BTRFSNAPD** is a simple daemon that automatically creates snapshots of **<u>BTRFS</u>** subvolumes at regular intervals. It is designed to be lightweight and easy to use, making it suitable for both personal and server environments. Being a full rewrite of the original **<u>btrfs-snapshot</u>** project, it aims to provide a more efficient and user-friendly experience.

### Features

- **Automatic Snapshots**: Create snapshots of BTRFS subvolumes at specified intervals.
- **Multiple Subvolumes**: Support for multiple subvolumes, allowing you to manage snapshots for different parts of your filesystem.
- **Retention Policy**: Automatically delete old snapshots based on a retention policy to save space.
- **Configuration File**: Easy-to-edit configuration file to customize snapshot settings.
- **Logging**: Detailed logging of snapshot creation and deletion activities for easy monitoring via system logs.
- **Systemd Integration**: Can be easily integrated with systemd for automatic startup and management.
- **Lightweight**: Minimal resource usage, making it suitable for both personal and server environments.

### Installation

#### Debian-based Systems

To install **BTRFSNAPD**, follow these steps on the official [apt repository](https://repository.howtonebie.com/) or download the latest [release](https://github.com/MichaelSchaecher/btrfsnapd/releases) Debian package: Install with `dpkg` command:

```console
sudo dpkg -i btrfsnapd_*.deb
```

#### Non-Debian Systems

Manual installation is also possible. You can clone the repository and run the script directly:

```console
git clone https://github.com/MichaelSchaecher/btrfsnapd.git
cd btrfsnapd
```

Copy the `btrfsnapd` script and related files to your desired location, such as `/usr/bin`, `/etc`. Manually installation on non-Debian systems will be available in the future.

### Configuration

The configuration file is located at `/etc/btrfsnapd.conf`. You can edit this file to specify the subvolumes you want to snapshot and the retention policy. Here is an example configuration:

```bash
#DISTRO_NAME="ubuntu"
```

Uncomment the line above and replace `"ubuntu"` with your distribution name to enable the configuration.

To change the default snapshot directory location, you can modify the `SNAPSHOT_DIR` variable in the configuration file:

```bash
SNAPSHOT_DIR="/path/to/your/snapshot/directory"
```

## Usage

If installed via package manager, the service will start automatically. You can check the status of the service with:

```console
systemctl status btrfsnapd.timer
```

To manually create a snapshot, you can run the following command:

```console
btrfsnapd create
```

Confirm that you want to create a snapshot by typing `[yY]` when prompted.

To delete old snapshots based on the retention policy, you can run:

```console
btrfsnapd delete
```

Answer `y` to confirm the deletion of old snapshots. To delete a specific snapshot, you can use: `btrfsnapd delete --list` and choose the snapshot you want to delete.

```console
btrfsnapd delete --list --yes
```

Will delete the chosen snapshot without further confirmation.

### Systemd Integration

To change the timer interval, you can edit the systemd timer with: `sudo systemctl edit btrfsnapd.timer`. This will open an editor where you can modify the timer settings. For example, to change the interval to every 30 minutes, you can add:

```ini
# Customize the timer interval for every 12 hours on 5 a.m. and 5 p.m.
OnCalendar=*-*-* 05:00:00,17:00:00
```

This will create snapshots at 5 a.m. and 5 p.m. every day. To apply the changes, run:

```console
sudo systemctl daemon-reload
sudo systemctl restart btrfsnapd.timer
```
