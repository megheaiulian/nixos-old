{ config, lib, pkgs, ... }:
{
  #all = import <nixpkgs> {};
  nixpkgs.overlays = [( self: super: {
     gkCurl = super.callPackage <nixpkgs/pkgs/tools/networking/curl> rec {
      fetchurl = super.fetchurlBoot;
      http2Support = true;
      zlibSupport = true;
      scpSupport = true;
      gnutlsSupport = true;
    };
    gitkraken = super.gitkraken.overrideAttrs(oldAttrs: rec {
      version = "3.3.3";
      name    = "gitkraken-${version}";

      src = super.fetchurl {
        url = "https://release.gitkraken.com/linux/v${version}.deb";
        sha256 = "154050mm5khkvmzxji4r3f4ivci6j4vrqm203bz527zn9zpxln0l";
      };

      libPath = super.stdenv.lib.makeLibraryPath [
        super.stdenv.cc.cc.lib
        self.gkCurl
        super.curl
        super.udev
        super.gnutls
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

      buildInputs = [ super.dpkg ];
      unpackPhase = "true";
      buildCommand = ''
        mkdir -p $out
        dpkg -x $src $out
        substituteInPlace $out/usr/share/applications/gitkraken.desktop \
          --replace /usr/share/gitkraken $out/bin
        cp -av $out/usr/* $out
        rm -rf $out/etc $out/usr $out/share/lintian
        chmod -R g-w $out

        for file in $(find $out -type f \( -perm /0111 -o -name \*.so\* \) ); do
          patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$file" || true
          patchelf --set-rpath ${libPath}:$out/share/gitkraken $file || true
        done

        find $out/share/gitkraken -name "*.node" -exec patchelf --set-rpath "${libPath}:$out/share/gitkraken" {} \; 

        rm $out/bin/gitkraken
        ln -s $out/share/gitkraken/gitkraken $out/bin/gitkraken
      '';
      });
   })];

  environment.systemPackages = with pkgs; [
    git-lfs
    gitkraken
  ];
}
