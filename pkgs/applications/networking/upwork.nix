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
        super.curl
        super.alsaLib
        super.xorg.libX11
        super.xorg.libXext
        super.xorg.libXcursor
        super.xorg.libXi
        super.glib
        super.udev
        super.xorg.libXScrnSaver
        super.xorg.libxkbfile
        super.xorg.libXtst
        super.nss
        super.nspr
        super.cups
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
        super.mesa
        super.xorg.libXinerama
      ] + ":${super.stdenv.cc.cc.lib}/lib64";

      buildInputs = [ super.dpkg ];
      unpackPhase = "true";
      buildCommand = ''
        mkdir -p $out
        dpkg -x $src $out
        cp -av $out/usr/* $out
        rm -rf $out/etc $out/usr $out/share/lintian
        chmod -R g-w $out

        for file in $(find $out -type f \( -perm /0111 -o -name \*.so\* \) ); do
          patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$file" || true
          patchelf --set-rpath ${libPath}:$out/share/upwork $file || true
        done
        rm $out/bin/upwork
        ln -s $out/share/upwork/upwork $out/bin/upwork
      '';

      meta = {
        homepage = "https://www.upwork.com";
      };
    };
  })];

  services.dbus.packages = with pkgs; [ gnome2.GConf upwork ];
  environment.systemPackages = with pkgs; [
    gnome2.GConf
    upwork
  ]; 
} 

