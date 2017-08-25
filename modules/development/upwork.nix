{ config, lib, pkgs, ... }:
{
  nixpkgs.overlays = [( self: super: {
    upwork = super.stdenv.mkDerivation rec {
      name      = "upwork-${version}";
      version   = "4.2.153";

      src  = super.fetchurl {
        url = "https://updates-desktopapp.upwork.com/binaries/v4_2_153_0_tkzkho5lhz15j08q/upwork_amd64.deb";
        sha256 = "19ya2s1aygxsz5mhrix991sz6alpxkwjkz2rxqlpblab95hiikw0";
      };

      libPath = super.stdenv.lib.makeLibraryPath [
        super.stdenv.cc.cc.lib
        super.curl
        super.udev
        super.alsaLib
        super.xorg.libX11
        super.xorg.libXext
        super.xorg.libXcursor
        super.xorg.libXi
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
        super.gnome2.gtkglext
        super.libgnome_keyring
        super.mesa
        super.xorg.libXinerama
        super.nss
      ];
      
      nativeBuildInputs = [ super.makeWrapper ];
      dontBuild = true;
      
      desktopItem = super.makeDesktopItem {
        name = "upwork";
        exec = "upwork";
        icon = "app";
        desktopName = "UpWork";
        genericName = "UpWork";
        categories = "Application;Development;";
        comment = "UpWork client";
      }; 

      buildInputs = [ super.dpkg ];
      unpackPhase = "dpkg-deb -x $src .";
      
      installPhase = ''
        mkdir -p "$out/opt/upwork"
        cp -r usr/share/upwork/* "$out/opt/upwork"
        mkdir -p "$out/share/applications"
        cp $desktopItem/share/applications/* "$out/share/applications"
        mkdir -p "$out/share/pixmaps"
        cp usr/share/pixmaps/upwork.png "$out/share/pixmaps"
      '';
      postFixup = ''
        for file in $(find $out -type f \( -perm /0111 -o -name \*.so\* \) ); do
          patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$file" || true
          patchelf --set-rpath ${libPath}:$out/opt/upwork $file || true
        done 
        wrapProgram $out/opt/upwork/upwork \
          --prefix LD_PRELOAD : "${super.stdenv.lib.makeLibraryPath [ super.curl ]}/libcurl.so.4" \
          --prefix LD_PRELOAD : "${super.stdenv.lib.makeLibraryPath [ super.libgnome_keyring ]}/libgnome-keyring.so.0" \
          --prefix LD_PRELOAD : "${super.stdenv.lib.makeLibraryPath [ super.mesa ]}/libGLU.so.1" \
          --prefix LD_PRELOAD : "${super.stdenv.lib.makeLibraryPath [super.nss ]}/libnssutil3.so" \
          --prefix LD_PRELOAD : "${super.stdenv.lib.makeLibraryPath [super.nss ]}/libsmime3.so" \
          --prefix LD_PRELOAD : "${super.stdenv.lib.makeLibraryPath [super.gnome2.GConf ]}/libgconf-2.so.4" \
          --prefix LD_PRELOAD : "${super.stdenv.lib.makeLibraryPath [super.alsaLib ]}/libasound.so.2"
        mkdir "$out/bin"
        ln -s "$out/opt/upwork/upwork" "$out/bin/upwork"
      '';

      meta = {
        homepage = "https://www.upwork.com";
      };
    };
  })];
  
  environment.systemPackages = with pkgs; [
    upwork
  ]; 
} 
