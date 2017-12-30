{ config, lib, pkgs, ... }:
{
  imports = [
    ../modules/desktops/gnome.nix
    ../modules/development/vagrant.nix
    ../modules/development/lxc.nix
    ../modules/development/lxd/lxd.nix
    ../modules/development/gitkraken.nix
    ../modules/development/vim.nix
    ../modules/development/tilix.nix
    ../modules/apps/skype.nix
  ];

  nixpkgs.config.allowUnfree = true;

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Europe/Bucharest";

  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
  };

  programs = {
    tmux.enable = true;
    fish.enable = true;
    java.enable = true;
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
    ag
    ];
}
