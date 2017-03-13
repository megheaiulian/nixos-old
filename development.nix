{ config, lib, pkgs, ... }:

{
  networking.extraHosts = ''
    10.231.136.2 project.local
  '';

  networking.bridges = {
    br0 = { interfaces = []; };
  };

  networking.interfaces = {
    br0 = {
      ip4 = [{ address = "10.231.136.1"; prefixLength = 24; }];
    };
  };

  containers.project = {
    privateNetwork = true;
    hostBridge = "br0";
    localAddress = "10.231.136.2/24";
    bindMounts.project = { hostPath = "path/to/project"; mountPoint="/project"; isReadOnly = false; };

    config =  { config, pkgs, ...}: {
      environment.systemPackages = with pkgs; [
        termite
      ];

      networking.firewall = {
        allowedTCPPorts = [80];
      };

      services.httpd = {
        enable = true;
        enableSSL = false;
        adminAddr = "dev@company.com";
        enablePHP = true;
        logPerVirtualHost = true;
        virtualHosts = [{
          extraConfig = ''
            DirectoryIndex index.php
          '';
          documentRoot = "/project/public";
          serverAliases  = ["project.local"];
        }];
      };

      services.mysql = {
        enable = true;
        package = pkgs.mysql;
        initialDatabases = [{
          name = "project";
          schema = "/project/project.local.sql";
        }];
        initialScript = ''
          GRANT ALL ON project.*
          TO project@localhost
          IDENTIFIED BY "pass";
        '';
      };
    };
  };
}
