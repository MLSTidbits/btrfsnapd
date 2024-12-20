---
title: BTRFS Snapshots Manger
section: 8
header: Manual
footer: BTRFS Snapshots Manger
author: Michael L. Schaecher <mschaecher78@gmail.com>
date: 2024-12-18
---

# NAME

BTRFS Snapshots Manger - a simple, but powerful way to manage **btrfs** snapshots.

# SYNOPSIS

**btrfs-snapshots-manager** [*command*]

# DESCRIPTION

Plus side of **btrfs** is its ability to create snapshots of subvolumes. Downside is that you have to manage them manually. **btrfs-snapshots-manager** is a simple, but powerful way to manage **btrfs** snapshots.

# COMMANDS

**create**
:   Create a snapshot of the root subvolume

**delete**
:   Delete a snapshot in the default location of system snapshots (e.g. /.snapshots)

**list**
:   List all snapshots

# SEE ALSO

btrfs(8)

# COPYRIGHT

**BTRFS Snapshots Manger** is licensed under the MIT License Copyright (c) 2024
