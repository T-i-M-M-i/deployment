{ config, pkgs, ... }:
{
  imports = [
    ../../modules/hetzner.nix
  ];

  system.stateVersion = "21.11";

  networking = {
    hostName = "staging";
    interfaces.ens3 = {
      ipv6.addresses = [ { address = "2a01:4f8:c010:214f::1"; prefixLength = 64; } ];
    };
  };


  ## TODO refactor nginx.nix to be reusable

  security.acme = {
    acceptTerms = true;
    email = "timmi_acme@johannesloetzsch.de";
    certs."${config.networking.fqdn}".extraDomainNames = [
      "prometheus-${config.networking.fqdn}"
    ];
  };

  services.nginx = {
    enable = true;
    virtualHosts = {
      "${config.networking.fqdn}" = {
        forceSSL = true;
        enableACME = true;
        root = "/var/www";
        extraConfig = ''autoindex on;'';
      };
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
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
