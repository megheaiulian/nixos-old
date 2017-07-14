{ config, lib, pkgs, ... }:
{
  nixpkgs.overlays = [( self: super: {
   lxc = super.lxc.overrideAttrs(oldAttrs: rec {
     postPatch = ''
       sed -i '/chmod u+s/d' src/lxc/Makefile.am
     '';
   });
  })];

  environment.systemPackages = with pkgs; [
    dnsmasq
  ];

  #services = {
  #  dnsmasq.enable = false;
  #  dnsmasq.extraConfig = ''
  #    bind-interfaces
  #    except-interface=lxcbr0
  #    listen-address=127.0.0.1
  #    server=/local/10.0.3.1
  #  '';
  #};

  networking.networkmanager.insertNameservers = ["10.0.3.1"];
  virtualisation = {
    lxc = {
      enable = true;
      defaultConfig = ''
        lxc.aa_profile = unconfined
        lxc.network.type = veth
        lxc.network.link = lxcbr0
        lxc.network.flags = up
      '';
    };
  };

  systemd.services.lxc-net = {
    after     = [ "network.target" "systemd-resolved.service" ];
    wantedBy  = [ "multi-user.target" ];
    path      = [ pkgs.dnsmasq pkgs.lxc pkgs.iproute pkgs.iptables pkgs.glibc];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
      ExecStart = "${pkgs.lxc}/libexec/lxc/lxc-net start";
      ExecStop  = "${pkgs.lxc}/libexec/lxc/lxc-net stop";
    };
  };
}
