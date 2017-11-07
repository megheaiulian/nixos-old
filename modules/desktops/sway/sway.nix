{ config, lib, pkgs, ... }:
let 
  buildDocs = true;
in
{
  nixpkgs.overlays = [( self: super: {
    sway = with super; stdenv.mkDerivation rec {
      name = "sway-${version}";
      version = "0.15-rc4";

      src = fetchFromGitHub {
        owner = "Sircmpwn";
        repo = "sway";
        rev = "${version}";
        sha256 = "0m14k5xdix9wiajmp9vnm24m9ci2dha0bf69v0xgjqn6mydvvrri";
      };

      nativeBuildInputs = [
        cmake pkgconfig
      ] ++ stdenv.lib.optional buildDocs [ asciidoc libxslt docbook_xsl ];
      buildInputs = [
        wayland pkgs.wlcc libxkbcommon pcre json_c dbus_libs
        pango cairo libinput libcap pam gdk_pixbuf xorg.libpthreadstubs
        libsecret
        xorg.libXdmcp
      ];

      enableParallelBuilding = true;

      cmakeFlags = "-DVERSION=${version}"; 
    }; 
  })];
}

