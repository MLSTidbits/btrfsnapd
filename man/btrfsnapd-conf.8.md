---
title: BTRFS-SNAPSHOT-CONFIG
section: 8
header: Manual Page
footer: Management of Btrfs Snapshots
author: Michael Lee Schaecher <michaelleeschaecher@gmail.com>
version: 1.0
date: 2025-06-12
---

# NAME

_btrfs-snapshot_ - Management of Btrfs Snapshots

# SYNOPSIS

_btrfs-snapshot_ [create|delete|restore|list|version|help] \<options\> arg...

# DESCRIPTION

_btrfs-snapshot_ is a command-line utility for managing Btrfs snapshots. It allows users to create, delete, restore, and list snapshots of Btrfs filesystems. Snapshots are useful for backup and recovery purposes, as they capture the state of the filesystem at a specific point in time.

Take the guesswork out of how to create/delete a snapshot or restore from a snapshot. The _btrfs-snapshot_ utility simplifies the process and provides additional options for managing snapshots.

- Create a snapshot before changes are made to installed package.
- Create a new snapshot on schedule.
- Delete the oldest snapshot based on how many you want to keep.
- Make restoring from a snapshot easier.

# CONFIGURATION

_btrfs-snapshot_ is configured via the `/etc/btrfs-snapshot.conf` file. This file contains the configuration for the snapshot creation process, including the source and target directories.

## SNAPSHOT_DIR

The directory where snapshots are stored. This is should be a Btrfs subvolume that is used to hold snapshots. If one does not exist, it need to be set first. See _btrfs(8)_ for more information on creating subvolumes.

---

:   Default: /.snapshots

---

:   Example: `SNAPSHOT_DIR="/mnt/.snapshots"`

## DISTRO_NAME

The name of the distribution for which snapshots are being managed. This is used to identify the snapshots in the list and when restoring.

---

:   Default is to let the utility determine the distribution name based on the system.

---

:   Example: `DISTRO_NAME="ubuntu"`

## SNAPSHOT_TYPE

The type of snapshot to create. What general subvolume is being snapshot; in most cases this is the root subvolume and should not be changed. The options are `root`, `home` or `log`.

---

:   Default: `root`

---

:   Example: `SNAPSHOT_TYPE="home"`

## SET_DATE

Whether to set the date in the snapshot name. If set to `true`, the snapshot name will include the date and time of creation.

---

:   Default: `true`

---

:   Example: `SET_DATE="false"`

## READ_ONLY

Whether to create the snapshot as read-only. If set to `true`, the snapshot will be created as read-only, preventing any further modifications to the snapshot after creation. This is useful for preserving the state of the filesystem without allowing further modifications. However, this can be changed later with the `-w` or `--writeable` option.

> _NOTE_: Booting from a read-only snapshot is not recommended, as it may cause issues with the system.

---

:   Default: `false`

---

:   Example: `READ_ONLY="true"`

## TOTAL_COUNT

The total number of snapshots to keep. This is used to determine how many snapshots to retain before deleting the oldest ones. If set to `0`, no snapshots will be deleted automatically. BTRFS snapshots do take up space so it is recommended to keep a reasonable number of snapshots to avoid running out of space on the filesystem.

---

:   Default: `7`

---

:   Example: `TOTAL_COUNT="5"`

# FILE

`/etc/btrfs-snapshot.conf`

# SEE ALSO

_btrfs(8)_, _btrfs-snapshot(8)_, _btrfs-subvolume(8)_

# COPYRIGHT

This manual page is part of the _btrfs-snapshot_ project, which is released under the GPU Public License (GPL) version 3 or later. For more information about the license go to <https://www.gnu.org/licenses/gpl-3.0.html>.

Copyright (C) 2025 Michael Lee Schaecher <michaelleeschaecher@gmail.com>
