{ config, pkgs, lib, ... }:

with lib;

let
  sway = pkgs.sway;
  swayWrapped = pkgs.writeScriptBin "sway" ''
    #! ${pkgs.stdenv.shell}
    export XKB_DEFAULT_LAYOUT=us,de
    export XKB_DEFAULT_VARIANT=,nodeadkeys
    export XKB_DEFAULT_OPTIONS=grp:alt_shift_toggle,
 
    PATH="${sway}/bin:$PATH"
    exec ${pkgs.dbus.dbus-launch} --exit-with-session sway-setcap
  '';

  swayJoined = pkgs.symlinkJoin {
    name = "sway-wrapped";
    paths = [ swayWrapped sway ];
  };

  swayExtra = with pkgs; [
    i3status
    xwayland 
    dmenu 
    rofi
    i3blocks
    brightnessctl
    paper-gtk-theme
    paper-icon-theme
    gnome3.gnome-disk-utility
    alacritty
    gnome3.dconf-editor
  ];

in
{
  environment.systemPackages = [ swayJoined ] ++ swayExtra;
  security.wrappers.sway = {
    program = "sway-setcap";
    source = "${sway}/bin/sway";
    capabilities = "cap_sys_ptrace,cap_sys_tty_config=eip";
    owner = "root";
    group = "sway";
    permissions = "u+rx,g+rx";
  };

  users.extraGroups.sway = {};

  hardware.opengl.enable = mkDefault true;
  fonts.enableDefaultFonts = mkDefault true;

  services.xserver = {
    desktopManager.session = [{
      name  = "sway";
      start = ''
        export GDK_BACKEND=wayland
        # export GDK_SCALE=2
        # export GDK_DPI_SCALE=0.5
        sway -d 2> ~/sway.log & waitPID=$!
      '';
    }];
    desktopManager.kodi.enable = true;
  }; 
  networking.networkmanager.enable = true; 
  services.xserver.libinput = {
    enable = true;
    naturalScrolling = true;
  }; 
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="/run/current-system/sw/bin/chgrp video /sys/class/backlight/%k/brightness"
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="/run/current-system/sw/bin/chmod g+w /sys/class/backlight/%k/brightness"
  '';
  
  services.dbus.packages = with pkgs; [ gnome3.dconf ];
} 

