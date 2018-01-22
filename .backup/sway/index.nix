{ config, pkgs, lib, ... }:
{
  imports = [
    #./alacritty.nix
    ./brightnessctl.nix
    ./wlc.nix
    ./sway.nix
    ./config.nix
  ];
} 
