# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
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
    nat = {
       enable = true;
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
     nfs-utils
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
  
  #virtualisation = {
    #lxc = {
      #enable = true;
      #defaultConfig = ''
      #  lxc.aa_profile = unconfined
      #  lxc.network.type = veth
      #  lxc.network.link = lxcbr0
      #  lxc.network.flags = up
      #'';
      #usernetConfig = ''
      #	iulian veth lxc0 10
      #  root veth lxc0 10
      #'';
    #};

   # virtualbox.host.enable = true;
  #};

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
    };
    #extraGroups.vboxusers.members = [ "iulian" ];
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.09";

}
