{ config, pkgs, lib, ... }:
{
  imports = [
    ./brightnessctl.nix
    ./wlc.nix
    ./sway.nix
    ./config.nix
  ];
} 
