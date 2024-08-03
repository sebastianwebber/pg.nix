# pg.nix

Experiments with nix and postgres!

> [!WARNING]
> This is a experiment to play with nix and postgres.
> **Production usage is not recomened.**

## Goals

This project aims to create a flake to setup postgres with patroni and consul.


## Deploy nodes

### Preparing the zfs disks 

> [!CAUTION]
> Run this task only once.

```shell
## start the shell
nix-shell -p vim -p tmux -p git -p zfs

git clone git@github.com:sebastianwebber/pg.nix.git
cd pg.nix
modprobe zfs

### create the disk pools
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ./host-config/disko.nix

### now fix the mounts
zpool export zdata
zpool import  zdata
```

Now you can rebuild the system.

### Rebuilding

Whenever you change something, run:

```shell
nixos-rebuild switch --flake ".#db-node-1"
```