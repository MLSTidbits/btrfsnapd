<div
  align="right">
  <img
    src="image/logo.png"
    alt="BTRFSNAPD Logo"
    width="auto"
    height="360"
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

To install **BTRFSNAPD**, follow these steps on the official [apt repository](https://repository.howtonebie.com/)

```console
sudo apt install --yes btrfsnapd
```

#### Non-Debian Systems

Manual installation is also possible for non-Debian systems. You can clone the repository and run the `configure` script to set up the necessary files.

```console
git clone https://github.com/MichaelSchaecher/btrfsnapd.git
cd btrfsnapd
sudo ./configure install
```

## BTRFS Subvolumes

Once installed successfully, you can start using **BTRFSNAPD** by configuring the subvolumes you want to snapshot in the configuration file located at `/etc/btrfsnapd.conf`. By default, the directory for snapshots is `/.snapshots`. It needs to be created manually before the first snapshot is taken.

```console
sudo mkdir -p /.snapshots
mount /dev/<your-btrfs-device> /mnt
sudo btrfs subvolume create /mnt/@snapshots
sudo umount /mnt
```

Now mount the BTRFS device again and ensure that the subvolume is mounted correctly, making sure that you use the same mount options in your `/etc/fstab` file:

```console
sudo mount -o subvol=@snapshots /dev/<your-btrfs-device> /.snapshots
```

> **Note**: If [Ubuntu](https://ubuntu.com/) what installed with the new installer, no subvolume will be created by default. You can create it manually with `btrfs subvolume create /.snapshots`. The downside to the way the new installer treats BTRFS is that it does not create a sepparate subvolume for the root filesystem and home directory. This means that snapshots will include all data, which may not be desired in some cases.
>
> It is recommended to create separate subvolumes for root and home directories to manage snapshots more effectively. This process needs to be done from a live environment or recovery mode to avoid issues with making changes to the root filesystem while booted into said environment.

## Configuration

The configuration file is located at `/etc/btrfsnapd.conf`. You can edit this file to specify the subvolumes you want to snapshot and the retention policy. Here is an example configuration:

```bash
#DISTRO_NAME="Ubuntu"
```

Uncomment the line above and replace `"Ubuntu"` with your distribution name to enable the configuration.

To change the default snapshot directory location, you can modify the `SNAPSHOT_DIR` variable in the configuration file:

```bash
SNAPSHOT_DIR="/path/to/your/snapshot/directory"
```

## Usage

Weather you installed **BTRFSNAPD** via the package manager or manually, the daemon well be be started automatically and take a snapshot according to the defaults if the configuration values are not changed. You can check the status of the daemon using:

```console
sudo systemctl status btrfsnapd.timer
```

### Creating Snapshots

To manually trigger a snapshot, you can use the following command: `sudo btrfsnapd create --source <root|home|logs> --yes`. This will create a snapshot of the specified subvolume. The `--yes` flag is used to skip confirmation prompts. if you want to set target directory the snapshot will be created in, you can use the `--target` with the path to the directory you want to create the snapshot in.

For example: `sudo btrfsnapd create --source root --target /path/to/snapshot/directory --yes`.

### Deleting Snapshots

The default number of snapshots to keep is 7 total of all snapshots. You can change this by editing the `TOTAL_COUNT` variable in the configuration file. Once the number of snapshots exceeds the specified limit, the oldest snapshots will be deleted automatically. However, you can also manually delete snapshots using the `btrfsnapd delete` command. For example, to delete all snapshots of the root subvolume, you can use: `sudo btrfsnapd delete --oldest --yes`

If you need or want to delete a specific snapshot, you can use the the following _flags `--list`_ to list all snapshots and be presented with a choose menu to select the snapshot you want to delete. Once you selected the snapshot, you be prompted to confirm the deletion. If you want to skip the confirmation prompt, you can use the `--yes` flag.

### Listing Snapshots

To list all snapshots, you can use the `btrfsnapd list` command. This will display a list of all snapshots along with their names, sources, and creation dates. The output will look something like this:

```plaintext
Name              Source           Date
---------------------------------------------
snapshot1        root             2023-10-01 12:00:00
snapshot2        home             2023-10-02 14:30:00
snapshot3        logs             2023-10-03 16:45:00
```

### Restoring Snapshots

If either `grub-btrfsd` or `grub-btrfs` are installed then `btrfsnapd` is capable of restoring from snapshots if booted into a live snapshot. To restore a snapshot, you can use the `btrfsnapd restore` command followed by the name of the snapshot you want to restore. For example: `sudo btrfsnapd restore --list --source <root|home|logs>`. Once you selected the snapshot you want to restore, you will be prompted to confirm the restoration. If you want to skip the confirmation prompt, you can use the `--yes` flag.

The process with delete the source subvolume and replace it with the snapshot you selected. This means the source subvolume will restored to the state it was in when the snapshot was created. Be cautious when using this command, as it will overwrite the current state of the subvolume.

## Contributing

If you would like to contribute to **BTRFSNAPD**, feel free to submit a pull request or open an issue on the [GitHub repository](https://github.com/MichaelSchaecher/btrfsnapd). Contributions are welcome, any feedback or suggestions are appreciated. Contribution_Guideline
