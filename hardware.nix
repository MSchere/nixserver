{ config, pkgs, ... }: {
  boot.isContainer = true;
  boot.loader.grub.enable = false;

  systemd.mounts = [{
    where = "/sys/kernel/debug";
    enable = false;
  }];
}

