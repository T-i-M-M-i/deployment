{ config, pkgs, nixpkgs, ... }:
{
  imports = [
    ./common.nix
  ];

  security.acme.certs."${config.networking.fqdn}".extraDomainNames = [
    "prometheus-${config.networking.fqdn}"
  ];

  services.nginx.virtualHosts = {
    "prometheus-${config.networking.fqdn}" = {
      forceSSL = true;
      useACMEHost = config.networking.fqdn;
      basicAuthFile = "/etc/nginx/passwd";
      locations."/" = {
        proxyPass = "http://localhost:9090";
        extraConfig = "proxy_pass_header Authorization;";
      };
    };
  };
}
