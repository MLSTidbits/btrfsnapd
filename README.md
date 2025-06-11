<div
  align="center">
  <img
    src="image/logo.svg"
    alt="grub-btrfsd logo"
    width="580"
    height=auto
    style="display: block; margin: 0;"
  />
</div>

<h2
  align="center" style="margin-top: 48;font-size: 32px; font-weight: 700;">
  Introduction
</h2>

**BTRFS Snapshot** is simple way to manage BTRFS snapshots. It creates snapshots on a daily basis and deletes old snapshots to keep the disk usage under control. I designed this application to work on Debian/Ubuntu based installations that take advantage of BTRFS filesystem. However, it should work on any Linux distribution that supports BTRFS.

<h3
  style="margin-top: 24;font-size: 24px; font-weight: 600;">
  Features
</h3>

- Create snapshots on a daily basis using Systemd timers.
- Delete old snapshots to keep the disk usage under control.
- Easy to install and configure.

<h2
  align="center" style="margin-top: 48;font-size: 32px; font-weight: 700;">
  Installation
</h2>

To install **BTRFS Snapshot** just follow the setups posted on the [repository](https://repository.howtonebie.com) homepage. The installation is simple and straightforward, and it will guide you through the process of setting up the application on your system. Once you have the _APT_ repository added, you can install the application using the following command:

```bash
sudo apt install -y btrfs-snapshot
```

<h2
  align="center" style="margin-top: 48;font-size: 32px; font-weight: 700;">
  How and Why to Use
</h2>

**BTRFS Snapshot** is designed to be used on a daily basis to create snapshots of your BTRFS filesystem. The application will automatically create snapshots and delete old ones to keep the disk usage under control. You can configure the application to create snapshots at specific times and keep a certain number of snapshots.

<h3
  style="margin-top: 24;font-size: 24px; font-weight: 600;">
  Configuration
</h3>
To configure **BTRFS Snapshot**, you can edit the configuration file located at `/etc/btrfs-snapshot.conf`. The configuration file allows you to set the following options:

---

<h4
  style="margin-top: 24;font-size: 16px; font-weight: 600;">
  SNAPSHOT_DIR
</h4>

> The directory where the snapshots will be stored. For example the most common location are `/.snapshots`, `/.snapper` or `/.btrfs-snapshots`.
>
> Default: `/.snapshots`.

<h4
  style="margin-top: 24;font-size: 16px; font-weight: 600;">
  DISTRO_ID
</h4>

> This is the name of the distribution you are using. By default, this is set by what is stored in `/etc/os-release` file. If you want to override it, you can set it to any value you like.
>
> Default: `$(. /etc/os-release && echo $ID || echo "unknown")`.

<h4
  style="margin-top: 24;font-size: 16px; font-weight: 600;">
  SNAPSHOT_TYPE
</h4>

> The type of snapshots to create. The options are `root`, `home`, `log`, or `custom`. The `root` type is used for the root filesystem, `home` for user home directories, `log` for log files, and `custom` for any other type of snapshot you want to create.
>
> Default: `root`

<h4
  style="margin-top: 24;font-size: 16px; font-weight: 600;">
  SET_DATE
</h4>

> Whether to set the date in the snapshot name. This is recommended to keep track of when the snapshot was created.
>
> Default: `true`.

<h4
  style="margin-top: 24;font-size: 16px; font-weight: 600;">
  READ_ONLY
</h4>

> Whether to make the snapshots read-only. Booting from a read-only snapshot is bit more complicated. In order for this to work, you need to have the `/var/log`, `/var/cache`, and `/tmp` directories on a separate BTRFS subvolume.
>
> Default: `false`.

<h4
  style="margin-top: 24;font-size: 16px; font-weight: 600;">
  TOTAL_COUNT
</h4>

> The number of snapshots to keep.
>
> Default: `7`.

<h2
  align="center" style="margin-top: 48;font-size: 32px; font-weight: 700;">
  Contributing
</h2>

If you want to contribute to the project, you can do so by submitting a pull request on the [GitHub repository](https://github.com/MichaelSchaecher/btrfs-snapshot/pulls). You can also report issues or suggest new features by opening an issue on the repository.
