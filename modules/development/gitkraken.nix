{ config, lib, pkgs, ... }:
{
  nixpkgs.overlays = [( self: super: {
    gitkraken = super.gitkraken.overrideAttrs(oldAttrs: rec {
      name    = "gitkraken-2.6.0";
      version = "2.6.0";

      src = super.fetchurl {
        url = "https://release.gitkraken.com/linux/v2.6.0.deb";
        sha256 = "1msdwqp20pwaxv1a6maqb7wmaq00m8jpdga7fmbjcnpvkcdz49l7";
      };
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
    gitkraken
  ];
}
