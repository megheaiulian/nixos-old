{ config, lib, pkgs, ... }:
{
  nixpkgs.overlays = [( self: super: {
    skypeforlinux = super.skypeforlinux.overrideAttrs(oldAttrs: rec {
      name = "skypeforlinux-${version}";
      version = "8.11.0.4"; 
      src = super.fetchurl {
        url = "https://repo.skype.com/deb/pool/main/s/skypeforlinux/skypeforlinux_${version}_amd64.deb";
        sha256 = "1chwc4rqcwwim03n6nski5dar33bb1gnadbvcjg6gln3xqr0ipib"; 
      };       
    });
  })];
    
  environment.systemPackages = with pkgs; [
    skypeforlinux
  ];
}
