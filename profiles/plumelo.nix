{ config, lib, pkgs, ... }:
{
  imports = [
    ../modules/desktops/gnome.nix
    ../modules/development/vagrant.nix
    ../modules/development/lxc.nix
    ../modules/development/gitkraken.nix
    ../modules/development/atom.nix
    ../modules/development/vim/vim.nix
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
  };

  environment.systemPackages = with pkgs; [
    acl
    p7zip
    wget
    git
    neovim
    slack
    skype
    firefox
    chromium
    lm_sensors
  ];
}
