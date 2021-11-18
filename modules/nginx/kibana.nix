{ config, pkgs, nixpkgs, ... }:
{
  imports = [
    ./common.nix
  ];

  security.acme.certs."${config.networking.fqdn}".extraDomainNames = [
    "elasticsearch.${config.networking.domain}"
    "kibana.${config.networking.domain}"
  ];

  services.nginx.virtualHosts = {
    "elasticsearch.${config.networking.domain}" = {
      forceSSL = true;
      useACMEHost = config.networking.fqdn;
      basicAuthFile = config.sops.secrets."nginx-passwd".path;
      locations."/" = {
        proxyPass = "http://localhost:${toString config.services.elasticsearch.port}";
      };
    };
    "kibana.${config.networking.domain}" = {
      forceSSL = true;
      useACMEHost = config.networking.fqdn;
      basicAuthFile = config.sops.secrets."nginx-passwd".path;
      locations."/" = {
        proxyPass = "http://localhost:${toString config.services.kibana.port}";
        extraConfig = "proxy_pass_header Authorization;";
      };
    };
  };
}
