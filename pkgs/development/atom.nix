{ config, lib, pkgs, ... }:
{
  nixpkgs.overlays = [( self: super: {
    atom = super.atom.overrideAttrs(oldAttrs: rec {
      name = "atom-${version}";
      version = "1.22.1";

      src = super.fetchurl {
        url = "https://github.com/atom/atom/releases/download/v${version}/atom-amd64.deb";
        sha256 = "04pa4ppp6v78f1xacg49a20kfi1rrc51p8md4qjiyfwkvri3ran8";
        name = "${name}.deb";
      };
    });
  })];

  environment.systemPackages = with pkgs; [
    atom
  ];
}
