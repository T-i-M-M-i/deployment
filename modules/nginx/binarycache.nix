{ config, pkgs, nixpkgs, ... }:
{
  imports = [
    ./common.nix
  ];

  security.acme.certs."${config.networking.fqdn}".extraDomainNames = [
    "binarycache.${config.networking.domain}"
  ];

  services.nginx.virtualHosts = {
    "binarycache.${config.networking.domain}" = {
      forceSSL = true;
      useACMEHost = config.networking.fqdn;
      locations."/".extraConfig = ''
        proxy_pass http://localhost:${toString config.services.nix-serve.port};
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      '';
    };
  };
}
