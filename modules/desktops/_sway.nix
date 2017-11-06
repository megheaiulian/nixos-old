{ config, lib, pkgs, ... }:
{
  let
    xwaylandPatch = fetchpatch {
      url = "https://github.com/Cloudef/wlc/commit/a130f6006560fb8ac02fb59a90ced1659563f9ca.diff";
     sha256 = "0kzcbqklcyg8bganm65di8cif6dpc8bkrsvkjia09kr92lymxm2c";
    };

  nixpkgs.overlays = [( self: super: {
    wlcc = super.wlc.overrideAttrs(oldAttrs: rec {
      inherit super;
      name = "wlc-${version}";
      version = "0.0.10";

      src = fetchFromGitHub {
        owner = "Cloudef";
        repo = "wlc";
        rev = "v${version}";
        fetchSubmodules = true;
        sha256 = "09kvwhrpgkxlagn9lgqxc80jbg56djn29a6z0n6h0dsm90ysyb2k";
      };

      patches = [
        xwaylandPatch
      ];

      nativeBuildInputs = [ cmake pkgconfig ];

      buildInputs = [
        wayland pixman libxkbcommon libinput xcbutilwm xcbutilimage mesa_noglu
        libX11 dbus_libs wayland-protocols
        libpthreadstubs libXdmcp libXext ]
        ++ stdenv.lib.optionals withOptionalPackages [ zlib valgrind doxygen ];

      doCheck = true;
      checkTarget = "test";
      enableParallelBuilding = true;    
    });

    swaywm = super.sway.overrideAttrs(oldAttrs: rec {
      version = "0.13.0";
      name = "sway-${version}";
      src = super.fetchFromGitHub {
        owner = "Sircmpwn";
        repo = "sway";
        rev = "0.13.0";
        sha256 = "1vgk4rl51nx66yzpwg4yhnbj7wc30k5q0hh5lf8y0i1nvpal0p3q";
      };

      buildInputs = [ 
        super.wayland 
        self.wlcc
        super.libxkbcommon
        super.pixman
        super.fontconfig
        super.pcre
        super.json_c
        super.dbus_libs
        super.pango
        super.cairo
        super.libinput
        super.libcap
        super.xwayland
        super.pam
        super.gdk_pixbuf ];
      cmakeFlags = "-DVERSION=${version}";
    });
  })];

  environment.systemPackages = with pkgs; [
    swaywm
    gnome3.gnome_terminal
    dmenu
    rofi
    paper-gtk-theme
    paper-icon-theme
    gnome3.gnome-disk-utility 
  ]; 
  services.xserver.enable = true;
  services.xserver.windowManager.session = [{
    name  = "sway";
    start = ''
      export xkb_default_layout=us,ro
      export xkb_default_variant=,nodeadkeys
      export xkb_default_options=grp:alt_shift_toggle
      ${pkgs.swaywm}/bin/sway & waitPID=$!
    '';
  }];

  #setcap cap_sys_ptrace=eip ${pkgs.swaywm}/bin/sway;

  services.xserver.libinput.enable = true; 
  services.xserver.libinput.naturalScrolling = true;
  networking.networkmanager.enable = true;
}
