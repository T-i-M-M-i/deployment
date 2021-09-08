{ config, pkgs, nixpkgs, ... }:
{
  security.acme = {
    acceptTerms = true;
    email = "timmi_acme@johannesloetzsch.de";
    certs."test.timmi.johannesloetzsch.de".extraDomainNames = [
      "prometheus-test.timmi.johannesloetzsch.de"
      "client-test.timmi.johannesloetzsch.de"
      "server-test.timmi.johannesloetzsch.de"
      "invoice-test.timmi.johannesloetzsch.de"
      "binarycache.timmi.johannesloetzsch.de"
      "jenkins.timmi.johannesloetzsch.de"
      "grafana.timmi.johannesloetzsch.de"
      "elasticsearch.timmi.johannesloetzsch.de"
      "kibana.timmi.johannesloetzsch.de"
    ];
  };

  services.nginx = {
    enable = true;
    virtualHosts = {
      "test.timmi.johannesloetzsch.de" = {
        forceSSL = true;
        enableACME = true;
        root = "/var/www";
        extraConfig = ''autoindex on;'';
      };
      "prometheus-test.timmi.johannesloetzsch.de" = {
        forceSSL = true;
        useACMEHost = "test.timmi.johannesloetzsch.de";
        basicAuthFile = "/etc/nginx/passwd";
        locations."/" = {
          proxyPass = "http://localhost:9090";
          extraConfig = "proxy_pass_header Authorization;";
        };
      };
      "client-test.timmi.johannesloetzsch.de" = {
        #default = true;  ## to use staging.timmi.johannesloetzsch.de, we would need cors settings supporting multiple hosts
        forceSSL = true;
        useACMEHost = "test.timmi.johannesloetzsch.de";
        locations."/" = {
          proxyPass = "http://localhost:3000";
          proxyWebsockets = true;
          extraConfig = "proxy_pass_header Authorization;";
        };
      };
      "server-test.timmi.johannesloetzsch.de" = {
        forceSSL = true;
        useACMEHost = "test.timmi.johannesloetzsch.de";
        locations."/" = {
          proxyPass = "http://localhost:4000";
          extraConfig = "proxy_pass_header Authorization;";
        };
      };
      "invoice-test.timmi.johannesloetzsch.de" = {
        forceSSL = true;
        useACMEHost = "test.timmi.johannesloetzsch.de";
        locations."/" = {
          proxyPass = "http://localhost:2300";
        };
      };
      "binarycache.timmi.johannesloetzsch.de" = {
        forceSSL = true;
        useACMEHost = "test.timmi.johannesloetzsch.de";
        locations."/".extraConfig = ''
          proxy_pass http://localhost:${toString config.services.nix-serve.port};
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        '';
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
      "grafana.timmi.johannesloetzsch.de" = {
        forceSSL = true;
        useACMEHost = "test.timmi.johannesloetzsch.de";
        locations."/" = {
          proxyPass = "http://localhost:2342";
          proxyWebsockets = true;
          extraConfig = "proxy_pass_header Authorization;";
        };
      };
      "kibana.timmi.johannesloetzsch.de" = {
        forceSSL = true;
        useACMEHost = "test.timmi.johannesloetzsch.de";
        basicAuthFile = "/etc/nginx/passwd";
        locations."/" = {
          proxyPass = "http://localhost:${toString config.services.kibana.port}";
          extraConfig = "proxy_pass_header Authorization;";
        };
      };
      "elasticsearch.timmi.johannesloetzsch.de" = {
        forceSSL = true;
        useACMEHost = "test.timmi.johannesloetzsch.de";
        basicAuthFile = "/etc/nginx/passwd";
        locations."/" = {
          proxyPass = "http://localhost:${toString config.services.elasticsearch.port}";
        };
      };
    };
  };
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
