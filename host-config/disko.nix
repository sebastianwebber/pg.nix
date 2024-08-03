let
  zfsPartition = {
    size = "100%";
    content = {
      type = "zfs";
      pool = "zdata";
    };
  };
in {
  disko.devices = {
    disk = {
      extraVol1 = {
        type = "disk";
        device = "/dev/nvme1n1";
        content = {
          type = "gpt";
          partitions = { zfs = zfsPartition; };
        };
      };
      extraVol2 = {
        type = "disk";
        device = "/dev/nvme2n1";
        content = {
          type = "gpt";
          partitions = { zfs = zfsPartition; };
        };
      };
      extraVol3 = {
        type = "disk";
        device = "/dev/nvme3n1";
        content = {
          type = "gpt";
          partitions = { zfs = zfsPartition; };
        };
      };
    };
    zpool = {
      zdata = {
        type = "zpool";
        mode = "raidz2";
        mountpoint = "/data";

        datasets = {
          pgdata = {
            type = "zfs_fs";
            mountpoint = "/data/pgdata";
          };
        };
      };
    };
  };
}
