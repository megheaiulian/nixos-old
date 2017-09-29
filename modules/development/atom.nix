{ config, lib, pkgs, ... }:
{
  nixpkgs.overlays = [( self: super: {
    atom = super.atom.overrideAttrs(oldAttrs: rec {
      name = "atom-${version}";
      version = "1.20.1";

      src = super.fetchurl {
        url = "https://github.com/atom/atom/releases/download/v${version}/atom-amd64.deb";
        sha256 = "0mr82m3yv18ljai3r4ncr65bqhjwxyf1si77iza4ijk5zv1llp7i";
        name = "${name}.deb";
      };
    });
  })];

  environment.systemPackages = with pkgs; [
    atom
  ];
}
