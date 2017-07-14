# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      #./hardware-configuration.nix
      #./lxc.nix
      #./overlays.nix
    ];
  environment.systemPackages = with pkgs; [
    acl
    p7zip
    wget
    lm_sensors
    git
    gitkraken
    neovim
    atom
    slack
    skype
    firefox
    chromium

  
    python
  ];





}
