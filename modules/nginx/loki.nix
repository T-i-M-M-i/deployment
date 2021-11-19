{ config, pkgs, nixpkgs, ... }:
{
  imports = [
    ./common.nix
  ];

  security.acme.certs."${config.networking.fqdn}".extraDomainNames = [
    "loki-${config.networking.fqdn}"
  ];

  services.nginx.virtualHosts = {
    "loki-${config.networking.fqdn}" = {
      forceSSL = true;
      useACMEHost = config.networking.fqdn;
      basicAuthFile = config.sops.secrets."nginx-passwd".path;
      locations."/" = {
        proxyPass = "http://localhost:3100";
      };
    };
  };
}
