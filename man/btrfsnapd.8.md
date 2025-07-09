---
title: BTRFS-SNAPSHOT
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

## COMMANDS

_create_
: Create a new snapshot of a Btrfs filesystem. See the _[CREATE SNAPSHOT](#create-snapshot)_ section for details.

_delete_
: Delete an existing snapshot. See the _[DELETE SNAPSHOT](#delete-snapshot)_ section for details.

_restore_
: Restore a snapshot to the current state of the filesystem. See the _[RESTORE SNAPSHOT](#restore-snapshot)_ section for details.

_list_
: List all snapshots available on the Btrfs filesystem.

_version_
: Display the version of the btrfs-snapshot utility.

_help_
: Display help information for the btrfs-snapshot utility.

## OPTIONS

_-h_, _--help_
: Display help information and exit for the specified command [create, delete or restore].

## CREATE SNAPSHOT

Using _btrfs-snapshot_ to create a snapshot is rapper than using the _btrfs_ command directly. The _btrfs-snapshot_ utility simplifies the process and provides additional options for managing snapshots.

To create a snapshot, use the following command:

```bash
btrfs-snapshot create [options]
```

The `source` and `target` are specified in the _btrfs-snapshot.conf_ file, which is located in the `/etc/btrfs-snapshot/` directory. This file contains the configuration for the snapshot creation process, including the source and target directories.

_-r_, _--read-only_
: Create a read-only snapshot. This option is useful for preserving the state of the filesystem without allowing further modifications.

_-y_, _--yes_
: Automatically answer "yes" to any prompts during the snapshot creation process. This is useful for scripting or automation.

_-s_, _--source_ \<source\>
: Specify the source directory for the snapshot. This is the directory that will be snapshotted, typically the root of a Btrfs filesystem.
_NOTE_: overwrite default of `root` with the available options are `root`, `home`, `log`, or `snapd`.

_-t_, _--target_ \<target\>
: Specify the target directory for the snapshot. This is where the snapshot will be stored. If not specified, the target will default to `/.snapshots/`. _NOTE_: the target directory must be on the same BTRFS filesystem as the source directory.

_-w_, _--writeable_ \<snapshot\>
: Convert a read-only snapshot to a writeable snapshot. This option allows you to modify the contents of the snapshot after it has been created.

## DELETE SNAPSHOT

Deleting a snapshot is straightforward with the _btrfs-snapshot_ utility and can only be applied to subvolumes with a top-level higher then 5. To delete a snapshot can be picked from the list or specified by the user. Use the following command:

```bash
btrfs-snapshot delete [options] <snapshot>
```

_-l_, _--list_
: List all available snapshots before deletion. This is useful for confirming which snapshots are present and selecting the correct one to delete.

_-y_, _--yes_
: Automatically answer "yes" to any prompts during the snapshot deletion process. This is useful for scripting or automation.

_-p_, _--purge_ \<path\>
: Purge a specific snapshot by providing its path. This option allows you to delete a snapshot without listing it first. The path should be the full path to the snapshot directory.

_-k_, _--keep_ \<number\>
: Specify the number of snapshots to keep when deleting. This option allows you to retain a certain number of snapshots while deleting older ones. If not specified, the default behavior is used, which may vary based on the configuration in the _btrfs-snapshot.conf_ file.

## RESTORE SNAPSHOT

Restoring a snapshot allows you to revert the filesystem to a previous state captured by the snapshot. This is useful for recovering from accidental deletions or modifications. To restore a snapshot, use the following command:

```bash
btrfs-snapshot restore [options] <snapshot>
```

_-l_, _--list_
: List all available snapshots before restoration. This is useful for confirming which snapshots are present and selecting the correct one to restore.

_-y_, _--yes_
: Automatically answer "yes" to any prompts during the snapshot restoration process. This is useful for scripting or automation.

_-s_, _--source_ \<source\>
: Specify which source is to be restored. Equal to the _--source_ option in the _create_ command, this is the directory that will be restored, typically the root of a Btrfs filesystem. If not specified, it defaults to `root`.

# SCHEDULING

The _btrfs-snapshot_ utility uses _systemd_ to schedule snapshot creation and deletion tasks.

## EXAMPLES

---

To create a snapshot every day at 2 AM, you can use the following, editing with `systemctl edit btrfs-snapshot.timer`:

```ini
OnCalendar = *-*-* 02:00:00
```

Reload the systemd configuration with:

```bash
systemctl daemon-reload
```

---

To create a read-only snapshot of the root directory and store it in the default target directory, you can use `systemctl edit btrfs-snapshot.service`:

```ini
ExecStart = /usr/bin/btrfs-snapshot create --readonly --source root
```

# SEE ALSO

_btrfs(8)_, _btrfs-subvolume(8)_, _btrfs-snapshot-config(8)_

# COPYRIGHT

This manual page is part of the _btrfs-snapshot_ project, which is released under the GPU Public License (GPL) version 3 or later. For more information about the license go to <https://www.gnu.org/licenses/gpl-3.0.html>.

Copyright (C) 2025 Michael Lee Schaecher <michaelleeschaecher@gmail.com>
