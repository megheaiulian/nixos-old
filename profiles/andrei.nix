{ config, lib, pkgs, ... }:
{
  imports = [
    ./plumelo.nix
    ##../devices/spire.nix
  ];

  networking.hostName = "andreiWS";

  users = {
    groups.andrei = {
      gid = 1000;
    };
    users.andrei = {
      isNormalUser = true;
      uid = 1000;
      extraGroups = ["iulian" "wheel" "disk" "audio" "video" "networkmanager" "systemd-journal" "lxd" "sway"];
      initialPassword = "andrei";
    };
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  boot = {
    kernelPackages = pkgs.linuxPackages_4_14;
  };

  environment.systemPackages = with pkgs; [
    transmission_gtk
    epiphany
    ntfs3g
    tree
  ];
  nix.buildCores = 4;
}

