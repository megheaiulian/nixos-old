{ config, lib, pkgs, ... }:
{
  nixpkgs.overlays = [( self: super: {
    vagrant = super.vagrant.overrideAttrs(oldAttrs: rec {
      name = "vagrant-${version}";
      version = "1.9.8";
      arch = builtins.replaceStrings ["-linux" "-darwin"] ["" ""] super.stdenv.system;
      src = super.fetchurl {
        url = "https://releases.hashicorp.com/vagrant/${version}/vagrant_${version}_${arch}.deb";
        sha256 = "1iiz0zn65xh4gi0s8683chxqi3ibircih0bvgbj5fbnyp8vmdjxx";
      };
    });
  })];

  environment.systemPackages = with pkgs; [
    vagrant
    ansible_2_3
    redir
    bridge-utils
  ];
}
