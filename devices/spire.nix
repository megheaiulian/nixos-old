{ config, lib, pkgs, ... }:
{
  powerManagement = {
    enable = true;
  };
  boot.initrd.availableKernelModules = ["hid-logitech-hidpp"];
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  hardware = {
    cpu.intel.updateMicrocode = true;
    bluetooth.enable = false;
    pulseaudio = {
      enable = true;
    };
  };
}

