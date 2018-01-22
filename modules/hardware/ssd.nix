{ config, lib, pkgs, ... }:
{
  fileSystems."/".options = [
    "noatime"
    "nodiratime"
  ];
  zramSwap = {
    enable    = true;
    priority  = 6;
  };
  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
  };
  services.fstrim.enable = true;
}
