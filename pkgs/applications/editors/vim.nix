{ config, lib, pkgs, ... }:
{
  nixpkgs.overlays = [( self: super: {
    vim_plum = super.vim_configurable.customize {
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
}

