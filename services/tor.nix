{ config, lib, pkgs, ... }:
{
  services.tor = {
    enable = true;
    client.enable = true;
    torsocks.enable = true;
  };

  environment.systemPackages = with pkgs; [
    firefoxPackages.tor-browser
  ];

}
