{ config, pkgs, nixpkgs, ... }:
{
  security.acme = {
    acceptTerms = true;
    email = "timmi_acme@johannesloetzsch.de";
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
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
