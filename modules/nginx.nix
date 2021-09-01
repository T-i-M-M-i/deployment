{ config, pkgs, nixpkgs, ... }:
{
  security.acme = {
    acceptTerms = true;
    email = "timmi_acme@johannesloetzsch.de";
    certs."test.timmi.johannesloetzsch.de".extraDomainNames = [
      "prometheus.timmi.johannesloetzsch.de"
      "jenkins.timmi.johannesloetzsch.de"
      "staging.timmi.johannesloetzsch.de"
      "client-staging.timmi.johannesloetzsch.de"  ## default
      "server-staging.timmi.johannesloetzsch.de"
    ];
  };

  services.nginx = {
    enable = true;
    virtualHosts = {
      "test.timmi.johannesloetzsch.de" = {
        default = true;
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://localhost:3000";
          proxyWebsockets = true;
          extraConfig = "proxy_pass_header Authorization;";
        };
      };
      "prometheus.timmi.johannesloetzsch.de" = {
        forceSSL = true;
        useACMEHost = "test.timmi.johannesloetzsch.de";
        basicAuthFile = "/etc/nginx/passwd";
        locations."/" = {
          proxyPass = "http://localhost:9090";
          extraConfig = "proxy_pass_header Authorization;";
        };
      };
      "jenkins.timmi.johannesloetzsch.de" = {
        forceSSL = true;
        useACMEHost = "test.timmi.johannesloetzsch.de";
        locations."/" = {
          proxyPass = "http://localhost:8080";
          proxyWebsockets = true;
          extraConfig = "proxy_pass_header Authorization;";
        };
      };
      "server-staging.timmi.johannesloetzsch.de" = {
        forceSSL = true;
        useACMEHost = "test.timmi.johannesloetzsch.de";
        locations."/" = {
          proxyPass = "http://localhost:4000";
          extraConfig = "proxy_pass_header Authorization;";
        };
      };
    };
  };
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
