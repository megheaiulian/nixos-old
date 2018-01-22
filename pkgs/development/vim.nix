{ config, lib, pkgs, ... }:
{
  nixpkgs.overlays = [( self: super: {
    pvim = super.vim_configurable.customize {
      name = "vim";
      vimrcConfig.customRC = ''
        set expandtab
        set tabstop=2
        set softtabstop=2
        if filereadable($HOME . "/.vimrc")
          source ~/.vimrc
        endif
      '';
    };
  })];

  environment.systemPackages = with pkgs; [
    pvim
  ];

}
