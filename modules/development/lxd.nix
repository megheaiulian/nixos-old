{ config, lib, pkgs, ... }:
{
  nixpkgs.overlays = [( self: super: {
    lxd = super.lxd.overrideAttrs(oldAttrs: rec {
      name    = "lxd-${version}";
      version = "2.14";
      rev     = "lxd-${version}";
      src     = super.fetchFromGitHub {
        inherit rev;
        owner = "lxc";
        repo = "lxd";
        sha256 = "1jy60lb2m0497bnjj09qvflsj2rb0jjmlb8pm1xn5g4lpzibszjm";
      }; 
    }); 
  })];
}

