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
    kernelPackages = pkgs.linuxPackages_testing;
    #kernelParams = [
    #  "amdgpu.dc=1"
    #];
    kernelModules = [
    #  "amdgpu-pro"
      "coretemp"
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
  #services.xserver.videoDrivers = [ "nvidia" ];
}

