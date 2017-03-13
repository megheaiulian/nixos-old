# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      #./development.nix
    ];

  nixpkgs.config.allowUnfree = true;

  boot.loader = {
    grub = {
      enable = true;
      version = 2;
      device = "nodev";
      efiSupport = true;
      gfxmodeEfi = "1024x768";
    };
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "plumone";
    bridges = {
      lxcbr0 = { interfaces = []; };
    };
    interfaces = {
      lxcbr0 = {
        ip4 = [{
          address = "192.168.100.1";
          prefixLength = 24; }];
      };
    };
    dhcpcd.denyInterfaces = ["veth*"];
    nat = {
      enable = true;
      externalInterface  = "wlp1s0";
      internalInterfaces = ["lxcbr0"];
    };
  };

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Europe/Bucharest";

  environment.systemPackages = with pkgs; [
    wget
    lm_sensors
    git
    neovim
    termite
    atom
    slack
    firefox
    paper-gtk-theme
    paper-icon-theme
    chromium
    transmission_gtk
    vagrant
    ansible2
    lastpass-cli
    p7zip
    bridge-utils
    redir
  ];

  powerManagement.enable = true;
  services.tlp.enable = true;
  services.xserver = {
    enable = true;
    layout = "us";

    displayManager.gdm.enable = true;

    desktopManager = {
      kodi.enable = true;
      gnome3.enable = true;
      #default = "gnome3";
    };

    multitouch = {
      enable = true;
      invertScroll = true;
      ignorePalm = true;
    };

    xkbOptions = "eurosign:e";
  };

  services.nfs.server.enable = true;
  services.rpcbind.enable = true;

  virtualisation = {
    lxc = {
      enable = true;
      defaultConfig = ''
        lxc.aa_profile = unconfined
        lxc.network.type = veth
        lxc.network.link = lxcbr0
        lxc.network.flags = up
        #lxc.network.ipv4 = 192.168.100.2/24
        #lxc.network.ipv4.gateway = auto
      '';
      usernetConfig = ''
        iulian veth lxcbr0 10
        root veth lxcbr0 10
      '';
    };
  };

  programs = {
    tmux.enable = true;
    fish.enable = true;
  };

  users = {
    defaultUserShell = "/run/current-system/sw/bin/fish";
    extraUsers.iulian = {
      isNormalUser = true;
      uid = 1000;
      shell = "/run/current-system/sw/bin/fish";
      extraGroups = [ "wheel" "disk" "audio" "video" "networkmanager" "systemd-jgnurnal" "vboxusers"];
      initialPassword = "iulian";
    };
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.09";
}
