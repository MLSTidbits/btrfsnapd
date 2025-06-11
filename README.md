<div
  align="center">
  <image
    src="image/logo.svg"
    alt="grub-btrfsd logo"
    width="720px"
    height="480px"
    style="display: block; margin: 0 auto;"
  />
</div>

## Introduction

**BTRFS Snapshot** is simple way to manage BTRFS snapshots. It creates snapshots on a daily basis and deletes old snapshots to keep the disk usage under control. I designed this application to work on Debian/Ubuntu based installations that take advantage of BTRFS filesystem. However, it should work on any Linux distribution that supports BTRFS.

### Features

- Create snapshots on a daily basis using Systemd timers.
- Delete old snapshots to keep the disk usage under control.
- Easy to install and configure.

## Installation

### Using DPKG/APT

You can install the project using the following command on Debian/Ubuntu based distributions add the repository.

Add the source list:

```bash
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/HowToNebie.gpg] https://michaelschaecher.github.io/mls stable main" |
sudo tee /etc/apt/sources.list.d/howtonebie.list
```

Add the repository key:

```bash
wget -qO - https://raw.githubusercontent.com/MichaelSchaecher/mls/refs/heads/main/key/HowToNebie.gpg |
gpg --dearmor | sudo dd of=/usr/share/keyrings/HowToNebie.gpg
```

### Other Linux Distributions

Installing the project is straightforward. Follow these steps:

1. Clone the repository:

   ```bash
   git clone https://github.com/MichaelMure/btrfs-snapshot.git
   ```

2. Install the project:

   ```bash
   sudo make install
   ```

## Usage

**BTRFS Snapshot** is setup as a Systemd service and apt hook to create snapshots and delete old snapshots. The service is enabled by default and will create snapshots on a daily basis. You can also manually create snapshots by running the following command:

```bash
sudo btrfs-snapshot
```

Once everything is set up and running you can rest assured that your well be able to restore your system to a previous state in case of a failure.

## Configuration

The configuration file is located at `/etc/btrfs-snapshot.conf`. You can change the default values according to your needs.
