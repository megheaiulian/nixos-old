{ config, lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    paper-gtk-theme
    paper-icon-theme
    gnome3.gnome-disk-utility
  ];

  services.xserver = {
    enable = true;
    layout = "us";
    xkbOptions = "eurosign:e";

    displayManager.gdm.enable = true;
    desktopManager = {
      kodi.enable = true;
      gnome3.enable = true;
    };
  };
}
