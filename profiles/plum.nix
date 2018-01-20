{ config, lib, pkgs, ... }:
{
  imports = [
    ./plumelo.nix
    ../devices/spire.nix
    ../modules/development/upwork.nix
    #../services/tor.nix
  ];

  networking.hostName = "plumone";

  users = {
    defaultUserShell = "/run/current-system/sw/bin/fish";
    groups.iulian = {
      gid = 1000;
    };
    users.iulian = {
      isNormalUser = true;
      uid = 1000;
      extraGroups = ["iulian" "wheel" "disk" "audio" "video" "networkmanager" "systemd-journal" "lxd" "sway"];
      initialPassword = "iulian";
    };
  };

  environment.systemPackages = with pkgs; [
    transmission_gtk
    lastpass-cli
    epiphany
    ntfs3g
    tree
  ];

  zramSwap = {
    enable    = true;
    priority  = 6;
  };
}
