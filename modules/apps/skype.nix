{ config, lib, pkgs, ... }:
{
  nixpkgs.overlays = [( self: super: {
    skypeforlinux = super.skypeforlinux.overrideAttrs(oldAttrs: rec {
      name = "skypeforlinux-${version}";
      version = "8.11.0.4"; 
      src = super.fetchurl {
        url = "https://repo.skype.com/deb/pool/main/s/skypeforlinux/skypeforlinux_${version}_amd64.deb";
        sha256 = "1dq7k4zlqqsx7786phialia5xbpc3cp1wrjhqrvga09yg4dl505c"; 
      };       
    });
  })];
    
  environment.systemPackages = with pkgs; [
    skypeforlinux
  ];
}
