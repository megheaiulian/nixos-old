{ config, lib, pkgs, ... }:
{
  nixpkgs.overlays = [( self: super: {
    atom = super.atom.overrideAttrs(oldAttrs: rec {
      name = "atom-${version}";
      version = "1.19.5";

      src = super.fetchurl {
        url = "https://github.com/atom/atom/releases/download/v${version}/atom-amd64.deb";
        sha256 = "04zkyn6zrkdr71h8hh0lakfk3hvr2jclbj4l3dlk7rvmrzqp900b";
        name = "${name}.deb";
      };
    });
  })];

  environment.systemPackages = with pkgs; [
    atom
  ];
}
