{ config, pkgs, nixpkgs, ... }:
{
  imports = [
    ./common.nix
  ];

  security.acme.certs."${config.networking.fqdn}".extraDomainNames = [
    "grafana.${config.networking.domain}"
  ];

  services.nginx.virtualHosts = {
    "grafana.${config.networking.domain}" = {
      forceSSL = true;
      useACMEHost = config.networking.fqdn;
      locations."/" = {
        proxyPass = "http://localhost:2342";
        proxyWebsockets = true;
        extraConfig = "proxy_pass_header Authorization;";
      };
    };
  };
}
