{ config, pkgs, nixpkgs, ... }:
{
  imports = [
    ../../nginx/prometheus.nix
  ];

  services.prometheus = {
    enable = true;
    retentionTime = "3y";

    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" "meminfo" "filesystem" "filefd" "textfile" ];
      };
      blackbox = {
        enable = true;
        configFile = ./blackbox.yaml;  ## see https://github.com/prometheus/blackbox_exporter/blob/master/example.yml
      };
    };
    scrapeConfigs = [
      {
        job_name = config.networking.hostName;
        static_configs = [{
          targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ];
        }];
      }
      {
        job_name = "blackbox";
        metrics_path = "/probe";
        params = { module = [ "http_2xx" ]; };
        static_configs = [{
          targets = [
            "127.0.0.1:3000"
            "127.0.0.1:4000"
            "127.0.0.1:2300"
          ];
        }];
        relabel_configs = [
          { source_labels = [ "__address__" ]; target_label = "__param_target"; }
          { source_labels = [ "__param_target" ]; target_label = "instance"; }
          { target_label = "__address__"; replacement = "127.0.0.1:9115"; }
        ];
      }
      {
        job_name = "blackbox_timmi_client";
        metrics_path = "/probe";
        params = { module = [ "http_timmi_client_manifest" ]; };
        static_configs = [{
          targets = [
            "https://timmitransport.de/manifest.json"  ## at the heroku setup it returns an ssl error caused by missing alternative subject
            "https://www.timmitransport.de/manifest.json"
            "https://client-productive.servers.timmitransport.de/manifest.json"
            "https://client-staging.servers.timmitransport.de/manifest.json"
            "https://client-test.servers.timmitransport.de/manifest.json"
          ];
        }];
        relabel_configs = [
          { source_labels = [ "__address__" ]; target_label = "__param_target"; }
          { source_labels = [ "__param_target" ]; target_label = "instance"; }
          { target_label = "__address__"; replacement = "127.0.0.1:9115"; }
        ];
      }
      {
        job_name = "blackbox_timmi_server";
        metrics_path = "/probe";
        params = { module = [ "http_timmi_server" ]; };
        static_configs = [{
          targets = [
            "https://server-productive.servers.timmitransport.de"
            "https://server-staging.servers.timmitransport.de"
            "https://server-test.servers.timmitransport.de"
          ];
        }];
        relabel_configs = [
          { source_labels = [ "__address__" ]; target_label = "__param_target"; }
          { source_labels = [ "__param_target" ]; target_label = "instance"; }
          { target_label = "__address__"; replacement = "127.0.0.1:9115"; }
        ];
      }
      {
        job_name = "blackbox_timmi_invoice";
        metrics_path = "/probe";
        params = { module = [ "http_timmi_invoice" ]; };
        static_configs = [{
          targets = [
            "https://invoice-productive.servers.timmitransport.de"
            "https://invoice-staging.servers.timmitransport.de"
            "https://invoice-test.servers.timmitransport.de"
          ];
        }];
        relabel_configs = [
          { source_labels = [ "__address__" ]; target_label = "__param_target"; }
          { source_labels = [ "__param_target" ]; target_label = "instance"; }
          { target_label = "__address__"; replacement = "127.0.0.1:9115"; }
        ];
      }
    ];
  };
  #networking.firewall.allowedTCPPorts = [ 9090 ];  ## ssl+basicAuth via reverse-proxy only
}
