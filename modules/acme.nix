{ config, pkgs, nixpkgs, ... }:
{
  security.acme.acceptTerms = true;
  security.acme.email = "timmi_acme@johannesloetzsch.de";
  services.nginx = {
    enable = true;
    virtualHosts = {
      "timmi.johannesloetzsch.de" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://localhost:3000";  ## timmi client
          #proxyPass = "http://localhost:9090";  ## prometheus
          #proxyPass = "http://localhost:8080";  ## jenkins
          proxyWebsockets = true;
          extraConfig = "proxy_pass_header Authorization;";
        };
      };
    };
  };
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
