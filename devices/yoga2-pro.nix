{ config, lib, pkgs, ... }:
{
  boot = {
    blacklistedKernelModules = ["ideapad-laptop"];
  };

  powerManagement = {
    enable = true;
    cpuFreqGovernor = pkgs.lib.mkForce "performance";
  };

  environment.systemPackages = with pkgs; [
    yoga_fan
    smartmontools
    gsmartcontrol
  ];

  # services.smartd.enable = true;
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  hardware = {
    cpu.intel.updateMicrocode = true;
    bluetooth.enable = false;
    opengl.extraPackages = [ pkgs.vaapiIntel ];
  };
}
