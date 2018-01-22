{ config, lib, pkgs, ... }:
{
  imports = [
    # all new pkgs and/or overlays
    ../pkgs/all.nix

    # config
    ../modules/services/X11/gnome3.nix 
    ../modules/virtualisation/lxc.nix
    ../modules/virtualisation/lxd.nix
    ../modules/virtualisation/vagrant.nix
    ../modules/hardware/ssd.nix
  ];

  nixpkgs.config.allowUnfree = true;

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Europe/Bucharest";

  powerManagement = {
    enable = true;
  };

  programs = {
    tmux.enable = true;
    fish.enable = true;
    java.enable = true;
  };

  hardware = {
    pulseaudio = {
      enable = true;
    };
    cpu.intel.updateMicrocode = true;
    cpu.amd.updateMicrocode = true;
  };

  environment.systemPackages = with pkgs; [
    acl
    p7zip
    wget
    git
    slack
    firefox
    chromium
    google-chrome
    chromedriver
    lm_sensors
    nodejs
    libreoffice-fresh
    python35Packages.mps-youtube
    python35Packages.youtube-dl
    cava
    mpv
    ruby
    xsel
    atom
    parted
    gptfdisk
    unoconv
    atom
    vim_plum
    gitkraken
    ag
    keepassx-community
    skypeforlinux
  ];

  users.defaultUserShell = "/run/current-system/sw/bin/fish";
}
