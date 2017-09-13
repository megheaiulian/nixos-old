{ config, lib, pkgs, ... }:
{
  nixpkgs.overlays = [( self: super: {
    gitkraken = super.gitkraken.overrideAttrs(oldAttrs: rec {
      version = "2.7.0";
      name    = "gitkraken-${version}";

      src = super.fetchurl {
        url = "https://release.gitkraken.com/linux/v${version}.deb";
        sha256 = "0088vdn47563f0v9zhk1vggn3c2cfg8rhmifc6nw4zbss49si5gp";
      };
    
      libPath = super.stdenv.lib.makeLibraryPath [
        super.stdenv.cc.cc.lib
        super.curl
        super.udev
        super.xorg.libX11
        super.xorg.libXext
        super.xorg.libXcursor
        super.xorg.libXi
        super.xorg.libxcb
        super.glib
        super.xorg.libXScrnSaver
        super.xorg.libxkbfile
        super.xorg.libXtst
        super.nss
        super.nspr
        super.cups
        super.alsaLib
        super.expat
        super.gdk_pixbuf
        super.dbus
        super.xorg.libXdamage
        super.xorg.libXrandr
        super.atk
        super.pango
        super.cairo
        super.freetype
        super.fontconfig
        super.xorg.libXcomposite
        super.xorg.libXfixes
        super.xorg.libXrender
        super.gtk2
        super.gnome2.GConf
        super.libgnome_keyring
      ];

      nativeBuildInputs = [ super.makeWrapper ];

      dontBuild = true;

      desktopItem = super.makeDesktopItem {
        name = "gitkraken";
        exec = "gitkraken";
        icon = "app";
        desktopName = "GitKraken";
        genericName = "Git Client";
        categories = "Application;Development;";
        comment = "Graphical Git client from Axosoft";
      };

      buildInputs = [ super.dpkg ];

      unpackPhase = "dpkg-deb -x $src .";

      installPhase = ''
        mkdir -p "$out/opt/gitkraken"
        cp -r usr/share/gitkraken/* "$out/opt/gitkraken"

        mkdir -p "$out/share/applications"
        cp $desktopItem/share/applications/* "$out/share/applications"

        mkdir -p "$out/share/pixmaps"
        cp usr/share/pixmaps/app.png "$out/share/pixmaps"
      '';

      postFixup = ''
        patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
                --set-rpath "$libPath:$out/opt/gitkraken" "$out/opt/gitkraken/gitkraken"
        wrapProgram $out/opt/gitkraken/gitkraken \
          --prefix LD_PRELOAD : "${super.stdenv.lib.makeLibraryPath [ super.curl ]}/libcurl.so.4" \
          --prefix LD_PRELOAD : "${super.stdenv.lib.makeLibraryPath [ super.libgnome_keyring ]}/libgnome-keyring.so.0"
        mkdir "$out/bin"
        ln -s "$out/opt/gitkraken/gitkraken" "$out/bin/gitkraken"
      '';
    });   
   })];

  environment.systemPackages = with pkgs; [
    git-lfs
    gitkraken
  ];
}
