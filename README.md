<div align=center>
  <h1>BTRFS Snapshots Manager</h1>
    <p>Simple BTRFS snapshots manager made for Ubuntu, but works on any Linux distribution.</p>
</div>

## Introduction

**BTRFS Snapshots Manager** is simple way to manage BTRFS snapshots on systems that use BTRFS as root filesystem and none [Ubuntu](https://ubuntu.com) subvolume layout.

## Features

- Create snapshots on a daily basis using Systemd timers.
- Delete old snapshots to keep the disk usage under control.
- Easy to install and configure.

## Installation

1. Clone the repository:

```bash
git clone https://github.com/MichaelMure/btrfs-snapshots-manager.git
```

2. Build the project:

```bash
cd btrfs-snapshots-manager
make build
```

3. Install the project:

```bash
sudo make install
```

4. Build with **manpage** (optional) by adding `MANPAGE=y`.

## Configuration

The configuration file is located at `/etc/btrfs-snapshots-manager.conf`. You can change the default values to fit your needs before installing the project.
