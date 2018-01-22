{ config, lib, pkgs, ... }:
let
  xwaylandPatch = pkgs.fetchpatch {
    url = "https://github.com/Cloudef/wlc/commit/a130f6006560fb8ac02fb59a90ced1659563f9ca.diff";
    sha256 = "0kzcbqklcyg8bganm65di8cif6dpc8bkrsvkjia09kr92lymxm2c";
  };
  withOptionalPackages = true;
in
{
  nixpkgs.overlays = [( self: super: {
    wlcc = with super; stdenv.mkDerivation rec {
      name = "wlc-${version}";
      version = "0.0.11";

      src = fetchFromGitHub {
        owner = "Cloudef";
        repo = "wlc";
        rev = "v${version}";
        fetchSubmodules = true;
        sha256 = "1qnak907gjd35hq4b0rrhgb7kz5iwnirh8yk372yzxpgk7dq0gz9";
      };

      #patches = [
      #  xwaylandPatch
      #];

      nativeBuildInputs = [ cmake pkgconfig ];

      buildInputs = with xorg; [
        wayland pixman libxkbcommon libinput xcbutilwm xcbutilimage mesa_noglu
        libX11 dbus_libs wayland-protocols
        libpthreadstubs libXdmcp libXext zlib valgrind ]
        ++ stdenv.lib.optionals withOptionalPackages [ doxygen ];

      doCheck = true;
      checkTarget = "test";
      enableParallelBuilding = true;    
    };
  })];
}
