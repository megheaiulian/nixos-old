{ config, lib, pkgs, ... }:
{
  imports = [
    ./plumelo.nix
    ../devices/yoga2-pro.nix
    ../modules/development/upwork.nix
    ../modules/desktops/sway/index.nix
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
  ];
  
  zramSwap = {
    enable    = true;
    priority  = 6;
  };
}
