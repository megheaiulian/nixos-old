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
    rxvt_unicode
    dmenu 
    paper-gtk-theme
    paper-icon-theme
    gnome3.gnome-disk-utility 
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
    enable = true;
    layout = "us";
    xkbOptions = "eurosign:e";

    windowManager.session = [{
      name  = "sway";
      start = ''
        # export GDK_SCALE=2
        # export GDK_DPI_SCALE=0.5
        sway & waitPID=$!
      '';
    }];
  }; 
  networking.networkmanager.enable = true; 
  services.xserver.libinput = {
    enable = true;
    naturalScrolling = true;
  }; 
} 

