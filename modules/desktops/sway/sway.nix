{ config, lib, pkgs, ... }:
let 
  buildDocs = false;
in
{
  nixpkgs.overlays = [( self: super: {
    sway = with super; stdenv.mkDerivation rec {
      name = "sway-${version}";
      version = "0.14.0";

      src = fetchFromGitHub {
        owner = "Sircmpwn";
        repo = "sway";
        rev = "${version}";
        sha256 = "1l8v9cdzd44bm4q71d47vqg6933b8j42q1a61r362vz2la1rcpq2";
      };

      nativeBuildInputs = [
        cmake pkgconfig
      ] ++ stdenv.lib.optional buildDocs [ asciidoc libxslt docbook_xsl ];
      buildInputs = [
        wayland pkgs.wlcc libxkbcommon pcre json_c dbus_libs
        pango cairo libinput libcap pam gdk_pixbuf xorg.libpthreadstubs
        xorg.libXdmcp
      ];

      enableParallelBuilding = true;

      cmakeFlags = "-DVERSION=${version}"; 
    }; 
  })];
}

