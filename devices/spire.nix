{ config, lib, pkgs, ... }:
{
  powerManagement = {
    enable = true;
  };

  fileSystems."/".options = [
    "noatime"
    "nodiratime"
  ];

  boot = {
    initrd.availableKernelModules = [
      "hid-logitech-hidpp"
    ];
    kernelPackages = pkgs.linuxPackages_4_14;
    kernelModules = [
      "coretemp"
      "nct6775"
    ];
  };

  hardware = {
    cpu.intel.updateMicrocode = true;
    bluetooth.enable = false;
    pulseaudio = {
      enable = true;
    };
  };

  services.fstrim.enable = true;

  nix.buildCores = 16;
}

