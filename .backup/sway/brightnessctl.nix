{ config, lib, pkgs, ... }:
let 
  buildDocs = true;
in
{
  nixpkgs.overlays = [( self: super: {
    brightnessctl = with super; stdenv.mkDerivation rec {
      name = "brightnessctl-${version}";
      version = "0.3";

      src = fetchFromGitHub {
        owner = "Hummer12007";
        repo = "brightnessctl";
        rev = "${version}";
        sha256 = "1d5dh3ny4gvkjb373fgn98f29r62i1rhfh5whn598ysvpzak4y78";
      };

      nativeBuildInputs = [
        pkgconfig
      ];
      
      patchPhase = ''
        sed -i "s@\-m [$][{]MODE[}] @@g" Makefile;
      '';

      makeFlags = "PREFIX=$(out)";
      installPhase = "PREFIX=$out make install";

      enableParallelBuilding = true;
    }; 
  })];
}

