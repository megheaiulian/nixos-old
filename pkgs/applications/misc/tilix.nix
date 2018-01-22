{ config, lib, pkgs, ... }:
{
  nixpkgs.overlays = [( self: super: {
    tilix = super.tilix.overrideAttrs(oldAttrs: rec {
      name = "tilix-${version}";
      version = "1.7.1";
      src = super.fetchFromGitHub {
        owner = "gnunn1";
        repo = "tilix";
        rev = "${version}";
        sha256 = "0x0bnb26hjvxmvvd7c9k8fw97gcm3z5ssr6r8x90xbyyw6h58hhh";
      };
    });
  })];
}
