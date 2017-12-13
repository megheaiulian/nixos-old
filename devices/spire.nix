{ config, lib, pkgs, ... }:
{
  powerManagement = {
    enable = true;
  };
  boot.initrd.availableKernelModules = ["hid-logitech-hidpp"];
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];
  boot.kernelPackages = pkgs.linuxPackages_4_14;
  boot.kernelParams = ["amdgpu.dc=1"];
  boot.kernelModules = ["amdgpu-pro" "coretemp" "nct6775"];
  hardware = {
    cpu.intel.updateMicrocode = true;
    bluetooth.enable = false;
    pulseaudio = {
      enable = true;
    };
  };
}

