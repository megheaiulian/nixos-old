{ config, lib, pkgs, ... }:
let
  ruby = pkgs.ruby;
in 
{
  nixpkgs.overlays = [( self: super: {
    psych = super.stdenv.mkDerivation rec {
      name = "psych-3.0.2";
      env = super.bundlerEnv {
        name = "psych-3.0.2-gem";
        inherit ruby;
        gemdir = ./.;
      };

      buildInputs = [ super.makeWrapper ];

      phases = ["installPhase"];

      installPhase = ''
        mkdir -p $out/bin
      '';
    };
  })];
}
