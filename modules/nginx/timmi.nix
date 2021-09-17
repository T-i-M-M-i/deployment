{ config, pkgs, nixpkgs, ... }:
{
  imports = [
    ./common.nix
  ];

  security.acme.certs."${config.networking.fqdn}".extraDomainNames = [
    "client-${config.networking.fqdn}"
    "server-${config.networking.fqdn}"
    "invoice-${config.networking.fqdn}"
  ];

  services.nginx.virtualHosts = {
    "client-${config.networking.fqdn}" = {
      #default = true;  ## we would need cors settings supporting multiple hosts
      forceSSL = true;
      useACMEHost = config.networking.fqdn;
      locations."/" = {
        proxyPass = "http://localhost:3000";
        proxyWebsockets = true;
        extraConfig = "proxy_pass_header Authorization;";
      };
    };
    "server-${config.networking.fqdn}" = {
      forceSSL = true;
      useACMEHost = config.networking.fqdn;
      locations."/" = {
        proxyPass = "http://localhost:4000";
        extraConfig = "proxy_pass_header Authorization;";
      };
    };
    "invoice-${config.networking.fqdn}" = {
      forceSSL = true;
      useACMEHost = config.networking.fqdn;
      locations."/" = {
        proxyPass = "http://localhost:2300";
      };
    };
  };
}
