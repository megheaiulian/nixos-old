{ config, lib, pkgs, ... }:
{
  nixpkgs.overlays = [( self: super: {
    lxd = super.buildGoPackage rec {
      name = "lxd-${version}";
      version = "2.14";
      rev = "lxd-${version}";

      goPackagePath = "github.com/lxc/lxd";

      src = super.fetchFromGitHub {
        inherit rev;
        owner = "lxc";
        repo = "lxd";
        sha256 = "1jy60lb2m0497bnjj09qvflsj2rb0jjmlb8pm1xn5g4lpzibszjm";
      };

      goDeps = ./lxd-deps.nix;

      nativeBuildInputs = [ super.pkgconfig ];
      buildInputs = [ super.lxc ];

      meta = with super.stdenv.lib; {
        description = "Daemon based on liblxc offering a REST API to manage containers";
        homepage = https://linuxcontainers.org/lxd/;
        license = licenses.asl20;
        maintainers = with maintainers; [ globin fpletz ];
        platforms = platforms.linux;
      };
    }; 
  })];

  security.apparmor = {
    enable = true;
    profiles = [
      "${pkgs.lxc}/etc/apparmor.d/usr.bin.lxc-star" 
      "${pkgs.lxc}/etc/apparmor.d/lxc-containers"
    ];
    packages = [ pkgs.lxc ];
  };

  virtualisation.lxd.enable = true;
  systemd.services.lxd.path = with pkgs; [ gzip dnsmasq squashfsTools iproute iptables ];
}

