{ config, lib, pkgs, ... }:
{
  nixpkgs.overlays = [( self: super: {
    linux_4_15_r8 = super.callPackage <nixpkgs/pkgs/os-specific/linux/kernel/linux-testing.nix> {
      kernelPatches = with pkgs; [
        kernelPatches.bridge_stp_helper
        kernelPatches.modinst_arg_list_too_long
      ];
      argsOverride = with pkgs; rec {
        version = "4.15-rc8";
        modDirVersion = "4.15.0-rc8";
        extraMeta.branch = "4.15";

        src = fetchurl {
          url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
          sha256 = "15d24b47mfkfs2b0l54sq0yl3ylh5dnx23jknb2r7cq14wxiqmq3";
        };
      };
    };
  })];

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
    kernelPackages = pkgs.linuxPackagesFor pkgs.linux_4_15_r8;
    kernelModules = [
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
}

