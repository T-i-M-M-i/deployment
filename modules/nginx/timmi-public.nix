{ config, pkgs, nixpkgs, ... }:
{
  imports = [
    ./common.nix
  ];

  security.acme.certs."timmitransport.de".extraDomainNames = [
    "www.timmitransport.de"
    "server.timmitransport.de"
    "invoice.timmitransport.de"
  ];

  services.nginx.virtualHosts = {
    "timmitransport.de" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://localhost:3000";
        proxyWebsockets = true;
        extraConfig = "proxy_pass_header Authorization;";
      };
    };
    "www.timmitransport.de" = {
      forceSSL = true;
      useACMEHost = "timmitransport.de";
      locations."/" = {
        extraConfig = "rewrite ^/(.*)$ https://timmitransport.de/$1 permanent;";
      };
    };
    "server.timmitransport.de" = {
      forceSSL = true;
      useACMEHost = "timmitransport.de";
      locations."/" = {
        proxyPass = "http://localhost:4000";
        extraConfig = "proxy_pass_header Authorization;";
      };
    };
    "invoice.timmitransport.de" = {
      forceSSL = true;
      useACMEHost = "timmitransport.de";
      locations."/" = {
        proxyPass = "http://localhost:2300";
      };
    };
  };
}
