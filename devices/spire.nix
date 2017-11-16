{ config, lib, pkgs, ... }:
{
  powerManagement = {
    enable = true;
    cpuFreqGovernor = pkgs.lib.mkForce "performance";
  };
  boot.initrd.availableKernelModules = ["hid-logitech-hidpp"];
  # services.smartd.enable = true;
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  hardware = {
    cpu.intel.updateMicrocode = true;
    bluetooth.enable = false;
    pulseaudio = {
      enable = true;
    };
  };
}

