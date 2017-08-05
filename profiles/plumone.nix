{ config, lib, pkgs, ... }:
{
  imports = [
    ./plumelo.nix
    ../devices/yoga2-pro.nix
  ];

  networking.hostName = "plumone";

  users = {
    defaultUserShell = "/run/current-system/sw/bin/fish";
    users.iulian = {
      isNormalUser = true;
      uid = 1000;
      extraGroups = ["wheel" "disk" "audio" "video" "networkmanager" "systemd-journal" "lxd" ];
      initialPassword = "iulian";
    };
  };

  networking.firewall.allowedTCPPorts = [9988];
  environment.systemPackages = with pkgs; [
    transmission_gtk
    comical
    lastpass-cli
  ];
}
