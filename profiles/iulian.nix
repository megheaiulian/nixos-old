{ config, lib, pkgs, ... }:
{
  imports = [
    ./plumelo.nix
    ../modules/hardware/kernel/linux_4_15_r8.nix
  ];

  networking.hostName = "plumone";

  users = {
    groups.iulian = {
      gid = 1000;
    };
    users.iulian = {
      isNormalUser = true;
      uid = 1000;
      extraGroups = ["iulian" "wheel" "disk" "audio" "video" "networkmanager" "systemd-journal" "lxd"];
      initialPassword = "iulian";
    };
  };

  environment.systemPackages = with pkgs; [
    transmission_gtk
    epiphany
    ntfs3g
    tree
  ];

  boot = {
    initrd.availableKernelModules = [
      "hid-logitech-hidpp"
    ];
    kernelModules = [
      "coretemp"
    ];
  };

  nix.buildCores = 16;
}
