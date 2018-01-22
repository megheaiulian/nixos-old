{ config, lib, pkgs, ... }:
{
  nixpkgs.overlays = [ (self: super: {
    yoga_fan = super.stdenv.mkDerivation rec {
      name = "yoga_fan";
      version = "0.2";
      src = super.fetchFromGitHub {
        owner  = "enyone";
        repo   = "lenovo-yoga-fan-control";
        rev    = "a3c5af53a7dd63c3a5e8034757233f362fed5a5e";
        sha256 = "1pwz3y3dkcnjkisv3r7kd8zwlgjlc8y45md1h7n8ypyvpx2m85n0";
      };

	    buildInputs = [ super.cmake ];

      installPhase = ''
        mkdir -p $out/bin
        cp yoga_fan $out/bin/
      '';

    };
  })];
}
