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
    displayManager.gdm.wayland = true;
    desktopManager = {
      kodi.enable = true;
      gnome3.enable = true;
    };
  };
  
  services.gnome3 = {
    gnome-documents.enable = false;
    gnome-user-share.enable = false;
    gnome-online-miners.enable = false;
    #gnome-keyring.enable = pkgs.lib.mkForce false;
    #evolution-data-server.enable = pkgs.lib.mkForce false;
  };
}
