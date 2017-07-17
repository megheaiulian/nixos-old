{ config, lib, pkgs, ... }:
{
  imports = [./gtkd.nix ];

  nixpkgs.overlays = [( self: super: {
    tilix = super.stdenv.mkDerivation rec {
      name = "tilix-1.6.1";
      version = "1.6.1";

      src = super.fetchFromGitHub {
        owner = "gnunn1";
        repo = "tilix";
        rev = "1.6.1";
        sha256 = "10nw3q6s941dm44bkfryl1xclr1xy1vjr2n8w7g6kfahpcazf8f8";
      };

      nativeBuildInputs = [
        autoreconfHook dmd desktop_file_utils super.perlPackages.Po4a pkgconfig xdg_utils
        wrapGAppsHook
      ];
      buildInputs = [ super.gnome3.dconf gettext gsettings_desktop_schemas gtkd dbus ];

      preBuild = ''
        makeFlagsArray=(PERL5LIB="${super.perlPackages.Po4a}/lib/perl5")
      '';

      postInstall = with super.gnome3; ''
        ${glib.dev}/bin/glib-compile-schemas $out/share/glib-2.0/schemas
      '';


      preFixup = ''
        substituteInPlace $out/share/applications/com.gexperts.Tilix.desktop \
          --replace "Exec=tilix" "Exec=$out/bin/tilix"
      '';

      meta = with stdenv.lib; {
        description = "Tiling terminal emulator following the Gnome Human Interface Guidelines.";
        homepage = "https://gnunn1.github.io/tilix-web";
        licence = licenses.mpl20;
        maintainer = with maintainers; [ midchildan ];
        platforms = platforms.linux;
      };

      inherit (super) autoreconfHook dmd desktop_file_utils pkgconfig
        xdg_utils stdenv wrapGAppsHook gettext gsettings_desktop_schemas gtkd dbus;

    };
  })];

  environment.systemPackages = with pkgs; [
    tilix
  ];
}
