{ config, pkgs, nixpkgs, ... }:
{
  services.prometheus = {
    enable = true;
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
