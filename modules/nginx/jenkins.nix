{ config, pkgs, nixpkgs, ... }:
{
  imports = [
    ./common.nix
  ];

  security.acme.certs."${config.networking.fqdn}".extraDomainNames = [
    "jenkins.${config.networking.domain}"
  ];

  services.nginx.virtualHosts = {
    "jenkins.${config.networking.domain}" = {
      forceSSL = true;
      useACMEHost = config.networking.fqdn;
      locations."/" = {
        proxyPass = "http://localhost:8080";
        proxyWebsockets = true;
        extraConfig = "proxy_pass_header Authorization;";
      };
    };
  };
}
