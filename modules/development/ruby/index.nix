{ config, pkgs, lib, ... }:
{
  imports = [
    ./psych/default.nix
  ];

  environment.systemPackages = with pkgs; [
    bundix
    psych
  ];

}
