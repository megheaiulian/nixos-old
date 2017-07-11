# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./lxc.nix
      #./overlays.nix
    ];
  
  nixpkgs.config.allowUnfree = true;
  
  # Use the systemd-boot EFI boot loader.
  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
  };
  boot.loader = {
    grub = {
      enable  = true;
      version = 2;
      device  = "nodev";
      efiSupport = true;
      gfxmodeEfi = "1024x768";
    };
    efi.canTouchEfiVariables = true;
  };

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/Bucharest";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    wget
    lm_sensors
    git
    neovim
    atom
    slack
    skype
    firefox
    paper-gtk-theme
    paper-icon-theme
    chromium
    transmission_gtk
    vagrant
    gitkraken
    ansible_2_3
    redir
    bridge-utils
    acl
    gnome3.gnome-disk-utility
    comical
    lastpass-cli
    p7zip
    unetbootin
    python
  ];

  services.xserver = {
    enable = true;
    layout = "us";
    xkbOptions = "eurosign:e";

    displayManager.gdm.enable = true;
    desktopManager = {
      kodi.enable = true;
      gnome3.enable = true;
    };

    #libinput = {
    #  enable = true;
    #  tapping = true;
    #};
    #synaptics.enable = false;
  };
  #services.gnome3.gnome-keyring.enable = true;
  
  networking.hostName = "plumone";
  networking.firewall = {
    allowedTCPPorts = [ 8200 ];
    allowedUDPPorts = [ 1900 ];
  };
  programs = {
    tmux.enable = true;
    fish.enable = true;
    java.enable = true;
  };
  
  #services.minidlna = {
  #  enable = true;
  #  mediaDirs = ["/home/iulian/Downloads/Media/"];
  #};

  users = {
    defaultUserShell = "/run/current-system/sw/bin/fish";
    users.iulian = {
      isNormalUser = true;
      uid = 1000;
      extraGroups = ["wheel" "disk" "audio" "video" "networkmanager" "systemd-journal" ];
      initialPassword = "iulian";
    };
  };  

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.03";
}
