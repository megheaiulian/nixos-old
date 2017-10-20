{ config, lib, pkgs, ... }:
{
  nixpkgs.overlays = [( self: super: {
    hyper = super.hyper.overrideAttrs(oldAttrs: rec {
      version = "1.4.8";
      name = "hyper-${version}";
      
      src = super.fetchurl {
        url = "https://github.com/zeit/hyper/releases/download/${version}/hyper_${version}_amd64.deb";
        sha256 = "0v31z3p5h3qr8likifbq9kk08fpfyf8g1hrz6f6v90z4b2yhkf51";
      };
      
      libPath = with super; stdenv.lib.makeLibraryPath [
        stdenv.cc.cc gtk2 atk glib pango gdk_pixbuf cairo freetype fontconfig dbus
        xorg.libXi xorg.libXcursor xorg.libXdamage xorg.libXrandr xorg.libXcomposite xorg.libXext xorg.libXfixes xorg.libxcb
        xorg.libXrender xorg.libX11 xorg.libXtst xorg.libXScrnSaver gnome2.GConf nss nspr alsaLib cups expat libudev libpulseaudio
      ];
    
      installPhase = ''
        mkdir -p "$out/bin"
        mv opt "$out/"
        ln -s "$out/opt/Hyper/hyper" "$out/bin/hyper"
        patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" --set-rpath "${libPath}:\$ORIGIN" "$out/opt/Hyper/hyper"
        mv usr/* "$out/"
        substituteInPlace "$out/share/applications/hyper.desktop" \
          --replace /opt/Hyper $out/bin  
      '';
    });
  })];

  environment.systemPackages = with pkgs; [
    hyper
  ];
}
