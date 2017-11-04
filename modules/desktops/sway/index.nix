{ config, pkgs, lib, ... }:
{
  imports = [
    ./wlc.nix
    ./sway.nix
    ./config.nix
  ];
} 
