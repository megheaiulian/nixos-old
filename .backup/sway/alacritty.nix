{ config, lib, pkgs, ... }:
{
  #all = import <nixpkgs> {};
  nixpkgs.overlays = [( self: super: {
    alacritty = super.alacritty.overrideAttrs(oldAttrs: with super; rec {
      name="alacritty-0.0.1";
      src = fetchFromGitHub {
        owner = "jwilm";
        repo = "alacritty";
        rev = "f68558e9dcce97e0d4d842a2d5b62e31e4124210";
        sha256 = "16qyjkvgsgiw5h0ls9rr24hhrqz886wm7mfm93dbs3inpn5vhliz";
      };

      depsSha256 = "19lrj4i6vzmf22r6xg99zcwvzjpiar8pqin1m2nvv78xzxx5yvgb"; 
    }); 
   })];

  #environment.systemPackages = with pkgs; [
  #  git-lfs
  #  gitkraken
  #];
}

